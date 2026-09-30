# Local Windows PDF layout review using the OS renderer, with no extra packages.
# First: flutter test test/export/cut_report_pdf_test.dart --dart-define=REPORT_SAMPLE_DIR=.dart_tool/report_samples
param([string]$SampleDirectory = '.dart_tool/report_samples')
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Runtime.WindowsRuntime
$null = [Windows.Storage.StorageFile, Windows.Storage, ContentType=WindowsRuntime]
$null = [Windows.Data.Pdf.PdfDocument, Windows.Data.Pdf, ContentType=WindowsRuntime]
$null = [Windows.Storage.Streams.InMemoryRandomAccessStream, Windows.Storage.Streams, ContentType=WindowsRuntime]
$null = [Windows.Storage.Streams.DataReader, Windows.Storage.Streams, ContentType=WindowsRuntime]
$asOperation = [System.WindowsRuntimeSystemExtensions].GetMethods() | Where-Object {
    $_.Name -eq 'AsTask' -and $_.IsGenericMethod -and $_.GetGenericArguments().Count -eq 1 -and
    $_.GetParameters().Count -eq 1 -and $_.GetParameters()[0].ParameterType.Name -eq 'IAsyncOperation`1'
} | Select-Object -First 1
$asAction = [System.WindowsRuntimeSystemExtensions].GetMethods() | Where-Object {
    $_.Name -eq 'AsTask' -and -not $_.IsGenericMethod -and $_.GetParameters().Count -eq 1 -and
    $_.GetParameters()[0].ParameterType.Name -eq 'IAsyncAction'
} | Select-Object -First 1
function Wait-Operation($Operation, [Type]$ResultType) {
    $task = $asOperation.MakeGenericMethod($ResultType).Invoke($null, @($Operation))
    $task.GetAwaiter().GetResult()
}
function Wait-Action($Action) {
    $task = $asAction.Invoke($null, @($Action))
    $null = $task.GetAwaiter().GetResult()
}
$sampleRoot = (Resolve-Path -LiteralPath $SampleDirectory).Path
foreach ($file in Get-ChildItem -LiteralPath $sampleRoot -Filter '*.pdf') {
    $storageFile = Wait-Operation ([Windows.Storage.StorageFile]::GetFileFromPathAsync($file.FullName)) ([Windows.Storage.StorageFile])
    $pdf = Wait-Operation ([Windows.Data.Pdf.PdfDocument]::LoadFromFileAsync($storageFile)) ([Windows.Data.Pdf.PdfDocument])
    Write-Output "$($file.Name): $($pdf.PageCount) pages"
    # First and last pages cover headers, wrapping and continued cutting lists.
    foreach ($index in @(0, ($pdf.PageCount - 1)) | Select-Object -Unique) {
        $page = $pdf.GetPage([uint32]$index)
        $stream = New-Object Windows.Storage.Streams.InMemoryRandomAccessStream
        $options = New-Object Windows.Data.Pdf.PdfPageRenderOptions
        $options.DestinationWidth = 1100
        Wait-Action ($page.RenderToStreamAsync($stream, $options))
        $reader = New-Object Windows.Storage.Streams.DataReader($stream.GetInputStreamAt(0))
        $null = Wait-Operation ($reader.LoadAsync([uint32]$stream.Size)) ([uint32])
        $bytes = New-Object byte[] ([int]$stream.Size)
        $reader.ReadBytes($bytes)
        [System.IO.File]::WriteAllBytes((Join-Path $sampleRoot "$($file.BaseName)-$($index + 1).png"), $bytes)
        $reader.Dispose()
        $stream.Dispose()
        $page.Dispose()
    }
}
