Param(
  [string]$Configuration = "Release"
)
dotnet publish .\windows\src\AgentSvc\AgentSvc.csproj -c $Configuration -r win-x64 -p:PublishSingleFile=true -p:SelfContained=true -o ..\..\windows\agent\build
Write-Host "Published to windows\agent\build"
