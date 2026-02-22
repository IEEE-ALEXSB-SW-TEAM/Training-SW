curl 127.0.0.1:8000

$body = @{
    key = "name"
    value = "mohamed"
} | ConvertTo-Json

Invoke-RestMethod `
    -Method Post `
    -Uri "http://127.0.0.1:8000/write" `
    -ContentType "application/json" `
    -Body $body

curl "http://127.0.0.1:8000/read?key=name"