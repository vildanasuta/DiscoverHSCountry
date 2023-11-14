using System;
using RabbitMQ.Client;
using Microsoft.Extensions.DependencyInjection;
using RabbitMQ.Service;

class Program
{
    static void Main(string[] args)
    {
        var serviceProvider = ConfigureServices();

        if (serviceProvider is IDisposable disposable)
        {
            disposable.Dispose();
        }
    }

    static IServiceProvider ConfigureServices()
    {
        var services = new ServiceCollection();

        var factory = new ConnectionFactory
        {
            HostName = Environment.GetEnvironmentVariable("RABBITMQ_HOST") ?? "localhost",
            Port = int.Parse(Environment.GetEnvironmentVariable("RABBITMQ_PORT") ?? "5672"),
            UserName = Environment.GetEnvironmentVariable("RABBITMQ_USERNAME") ?? "guest",
            Password = Environment.GetEnvironmentVariable("RABBITMQ_PASSWORD") ?? "guest",
        };
        var connection = factory.CreateConnection();
        var channel = connection.CreateModel();

        services.AddTransient<IModel>(_ => (IModel)channel);
        services.AddTransient<RabbitMQEmailProducer>();
        services.AddTransient<EmailService>();

        return services.BuildServiceProvider();
    }
}
