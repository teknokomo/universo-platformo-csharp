using System.Threading.RateLimiting;
using Serilog;

namespace UniversoPlatformo.ApiHost;

/// <summary>
/// Main entry point for the Universo Platformo API Host.
/// This application composes and hosts all feature packages.
/// </summary>
public class Program
{
    public static void Main(string[] args)
    {
        // Configure Serilog for startup logging
        Log.Logger = new LoggerConfiguration()
            .WriteTo.Console()
            .WriteTo.File("logs/startup-.log", rollingInterval: RollingInterval.Day)
            .CreateBootstrapLogger();

        try
        {
            Log.Information("Starting Universo Platformo API Host");
            
            var builder = WebApplication.CreateBuilder(args);

            // Configure Serilog as the logging provider
            builder.Host.UseSerilog((context, services, configuration) => configuration
                .ReadFrom.Configuration(context.Configuration)
                .ReadFrom.Services(services)
                .Enrich.FromLogContext()
                .WriteTo.Console()
                .WriteTo.File("logs/api-host-.log", rollingInterval: RollingInterval.Day));

            // Add services to the container
            ConfigureServices(builder.Services, builder.Configuration);

            var app = builder.Build();

            // Configure the HTTP request pipeline
            ConfigureMiddleware(app);

            Log.Information("API Host configured successfully. Starting application...");
            
            app.Run();
        }
        catch (Exception ex)
        {
            Log.Fatal(ex, "Application terminated unexpectedly");
            throw;
        }
        finally
        {
            Log.CloseAndFlush();
        }
    }

    /// <summary>
    /// Configures services for dependency injection.
    /// </summary>
    private static void ConfigureServices(IServiceCollection services, IConfiguration configuration)
    {
        // Add controllers
        services.AddControllers();

        // Add API explorer for Swagger/OpenAPI
        services.AddEndpointsApiExplorer();
        services.AddSwaggerGen(options =>
        {
            options.SwaggerDoc("v1", new Microsoft.OpenApi.Models.OpenApiInfo
            {
                Title = "Universo Platformo API",
                Version = "v1",
                Description = "Main API host for Universo Platformo CSharp",
                Contact = new Microsoft.OpenApi.Models.OpenApiContact
                {
                    Name = "Universo Platformo Team"
                }
            });
        });

        // Add CORS support (will be configured in T142.7 with specific origins)
        // TODO T142.7: Replace with specific allowed origins for Blazor frontend
        services.AddCors(options =>
        {
            options.AddDefaultPolicy(policy =>
            {
                // Temporary permissive policy for development
                // MUST be restricted to specific origins in production
                policy.AllowAnyOrigin()
                      .AllowAnyMethod()
                      .AllowAnyHeader();
            });
        });

        // Add health checks
        services.AddHealthChecks();

        // Add memory cache
        services.AddMemoryCache();

        // Add distributed cache (Redis will be configured in T142.12)
        services.AddDistributedMemoryCache();

        // Add rate limiting (will be further configured in T142.5 and T142.13)
        services.AddRateLimiter(options =>
        {
            options.GlobalLimiter = PartitionedRateLimiter.Create<HttpContext, string>(context =>
                RateLimitPartition.GetFixedWindowLimiter(
                    // Use remote IP for rate limiting (more secure than Host header)
                    partitionKey: context.Connection.RemoteIpAddress?.ToString() ?? "unknown",
                    factory: partition => new FixedWindowRateLimiterOptions
                    {
                        AutoReplenishment = true,
                        PermitLimit = 100,
                        Window = TimeSpan.FromMinutes(1)
                    }));
        });

        // JWT Authentication will be configured in T142.8
        // Service registration from all -srv packages will be added in T142.4
        
        Log.Information("Services configured successfully");
    }

    /// <summary>
    /// Configures the middleware pipeline.
    /// </summary>
    private static void ConfigureMiddleware(WebApplication app)
    {
        // Enable Swagger (will be restricted to development in production deployments)
        // TODO: Consider restricting to Development environment only for security
        app.UseSwagger();
        app.UseSwaggerUI(options =>
        {
            options.SwaggerEndpoint("/swagger/v1/swagger.json", "Universo Platformo API v1");
            // Serve Swagger at root for initial development
            // TODO: Use a secure path like "api/docs" in production
            options.RoutePrefix = string.Empty;
        });

        // Use HTTPS redirection in production
        if (!app.Environment.IsDevelopment())
        {
            app.UseHttpsRedirection();
        }

        // Enable CORS
        app.UseCors();

        // Enable rate limiting
        app.UseRateLimiter();

        // Enable routing
        app.UseRouting();

        // Authentication and authorization middleware (will be configured in T142.8)
        // app.UseAuthentication();
        // app.UseAuthorization();

        // Map controllers
        app.MapControllers();

        // Map health check endpoint
        app.MapHealthChecks("/health");

        // Map a simple hello endpoint for testing
        app.MapGet("/api/hello", () => new
        {
            Message = "Hello from Universo Platformo API Host",
            Timestamp = DateTime.UtcNow,
            Environment = app.Environment.EnvironmentName
        })
        .WithName("Hello");

        Log.Information("Middleware pipeline configured successfully");
    }
}
