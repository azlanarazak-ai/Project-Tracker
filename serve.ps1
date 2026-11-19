$root = "C:\Users\Azlan\.ilmucode\workspace\default"
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:8471/")
$listener.Start()
Write-Host "Serving $root on http://localhost:8471/"
while ($listener.IsListening) {
  $ctx = $listener.GetContext()
  $rel = $ctx.Request.Url.AbsolutePath
  if ($rel -eq "/") { $rel = "/index.html" }
  $file = Join-Path $root ($rel.TrimStart("/") -replace "/", "\")
  if (Test-Path $file -PathType Leaf) {
    $bytes = [System.IO.File]::ReadAllBytes($file)
    $ctx.Response.ContentType = "text/html; charset=utf-8"
    $ctx.Response.ContentLength64 = $bytes.Length
    $ctx.Response.OutputStream.Write($bytes, 0, $bytes.Length)
  } else {
    $ctx.Response.StatusCode = 404
    $msg = [System.Text.Encoding]::UTF8.GetBytes("not found")
    $ctx.Response.OutputStream.Write($msg, 0, $msg.Length)
  }
  $ctx.Response.OutputStream.Close()
}
