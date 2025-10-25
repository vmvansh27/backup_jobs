using System.ServiceProcess;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Serilog;

internal class Program
{
    public static async Task Main(string[] args)
    {
        var builder = Host.CreateApplicationBuilder(args);
        builder.Services.AddWindowsService(o => o.ServiceName = "AgentSvc");
        Log.Logger = new LoggerConfiguration().WriteTo.File(@"C:\ProgramData\YourCo\logs\agent.log", rollingInterval: RollingInterval.Day).CreateLogger();
        builder.Logging.ClearProviders();
        builder.Logging.AddSerilog();

        builder.Services.AddHostedService<AgentWorker>();

        var app = builder.Build();
        await app.RunAsync();
    }
}

public sealed class AgentWorker : BackgroundService
{
    private readonly ILogger<AgentWorker> _log;
    public AgentWorker(ILogger<AgentWorker> log) => _log = log;

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        _log.LogInformation("AgentSvc started at {time}", DateTimeOffset.Now);
        while (!stoppingToken.IsCancellationRequested)
        {
            // heartbeat; simulate minimal health probe
            _log.LogInformation("AgentSvc heartbeat {time}", DateTimeOffset.Now);
            await Task.Delay(TimeSpan.FromMinutes(1), stoppingToken);
        }
        _log.LogInformation("AgentSvc stopping at {time}", DateTimeOffset.Now);
    }
}
