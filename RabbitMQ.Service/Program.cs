using System;
using System.Text;
using RabbitMQ.Client;
using RabbitMQ.Client.Events;
using Newtonsoft.Json;
using RabbitMQ.Service;

class Program
{
    static void Main()
    {
        ConnectionFactory factory = new ConnectionFactory();
        string rabbitHost = Environment.GetEnvironmentVariable("RABBITMQ_HOST") ?? "localhost";
        int rabbitPort = int.Parse(Environment.GetEnvironmentVariable("RABBITMQ_PORT") ?? "5672");
        string rabbitUsername = Environment.GetEnvironmentVariable("RABBITMQ_USERNAME") ?? "guest";
        string rabbitPassword = Environment.GetEnvironmentVariable("RABBITMQ_PASSWORD") ?? "guest";

        var uriString = $"amqp://{rabbitUsername}:{rabbitPassword}@{rabbitHost}:{rabbitPort}";
        factory.Uri = new Uri(uriString);
        factory.ClientProvidedName = "Rabbit Receiver1 App";

        using (IConnection connection = factory.CreateConnection())
        using (IModel channel = connection.CreateModel())
        {
            EmailService emailService = new EmailService(channel);

           // Console.WriteLine(" [*] Waiting for messages. To exit press CTRL+C");

            emailService.StartListening();

            Console.ReadLine();
        }
    }
}

