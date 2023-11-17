using Newtonsoft.Json;
using RabbitMQ.Client.Events;
using RabbitMQ.Client;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Mail;
using System.Net;
using System.Text;
using System.Threading.Tasks;

namespace RabbitMQ.Service
{
    public class EmailModelToParse
    {
        public string Sender { get; set; }
        public string Recipient { get; set; }
        public string Subject { get; set; }
        public string Content { get; set; }
    }
    public class EmailService : IDisposable
    {
        private readonly IModel _channel;

        public EmailService(IModel channel)
        {
            _channel = channel;
        }

        public void Dispose()
        {
            _channel?.Dispose();
        }

        public void StartListening()
        {
            try
            {
                ConnectionFactory factory = new ConnectionFactory();
                string rabbitHost = Environment.GetEnvironmentVariable("RABBITMQ_HOST") ?? "localhost";
                int rabbitPort = int.Parse(Environment.GetEnvironmentVariable("RABBITMQ_PORT") ?? "5672");
                string rabbitUsername = Environment.GetEnvironmentVariable("RABBITMQ_USERNAME") ?? "guest";
                string rabbitPassword = Environment.GetEnvironmentVariable("RABBITMQ_PASSWORD") ?? "guest";

                var uriString = $"amqp://{rabbitUsername}:{rabbitPassword}@{rabbitHost}:{rabbitPort}";
                factory.Uri = new Uri(uriString);
                factory.ClientProvidedName = "Rabbit Receiver1 App";
                IConnection connection = factory.CreateConnection();
                IModel channel = connection.CreateModel();

                string exchangeName = "EmailExchange";
                string routingKey = "email_queue";
                string queueName = "EmailQueue";


                channel.ExchangeDeclare(exchangeName, ExchangeType.Direct);
                channel.QueueDeclare(queueName, true, false, false, null);
                channel.QueueBind(queueName, exchangeName, routingKey, null);
                channel.BasicQos(0, 1, false);



                var consumer = new EventingBasicConsumer(channel);

                consumer.Received += (sender, args) =>
                {
                    var body = args.Body.ToArray();
                    string message = Encoding.UTF8.GetString(body);

                    SendEmail(message);

                    Console.WriteLine($"Message received: {message}");

                    _channel.BasicAck(args.DeliveryTag, false);
                };

                string consumerTag = _channel.BasicConsume(queueName, true, consumer);

                _channel.BasicCancel(consumerTag);
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error in StartListening: {ex.Message}");
            }
        }


        private void SendEmail(string message)
        {
            try
            {
                string smtpServer = Environment.GetEnvironmentVariable("SMTP_SERVER") ?? "smtp.gmail.com";
                int smtpPort = int.Parse(Environment.GetEnvironmentVariable("SMTP_PORT") ?? "587");
                string fromMail = Environment.GetEnvironmentVariable("SMTP_USERNAME") ?? "cdiscoverhs@gmail.com";
                string password = Environment.GetEnvironmentVariable("SMTP_PASSWORD") ?? "ircrhnghicdszqqu";

                var emailData = JsonConvert.DeserializeObject<EmailModelToParse>(message);
                var senderEmail = emailData.Sender;
                var recipientEmail = emailData.Recipient;
                var subject = emailData.Subject;
                var content = emailData.Content;

                MailMessage MailMessageObj = new MailMessage();

                MailMessageObj.From = new MailAddress(fromMail);
                MailMessageObj.Subject = subject;
                MailMessageObj.To.Add(recipientEmail);
                MailMessageObj.Body = content;

                var smtpClient = new SmtpClient()
                {
                    Host = smtpServer,
                    Port = smtpPort,
                    Credentials = new NetworkCredential(fromMail, password),
                    EnableSsl = true
                };

                smtpClient.Send(MailMessageObj);
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error sending email: {ex.Message}");
            }
        }

    }
}
