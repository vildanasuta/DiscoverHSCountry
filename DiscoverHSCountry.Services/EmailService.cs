using Newtonsoft.Json;
using RabbitMQ.Client;
using RabbitMQ.Client.Events;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Mail;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using System.Threading.Channels;

namespace DiscoverHSCountry.Services
{
    public class EmailService: IDisposable
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
            ConnectionFactory factory = new ConnectionFactory();
            var uriString = "amqp://guest:guest@localhost:5672";

            factory.Uri = new Uri(uriString);
            factory.ClientProvidedName = "Rabbit Receiver1 App";

            IConnection connection = factory.CreateConnection();
            IModel channel = connection.CreateModel();

            string exchangeName = "EmailExchange";
            string routingKey = "email_queue";
            string queueName = "EmailQueue";


            channel.ExchangeDeclare(exchangeName, ExchangeType.Direct);
            channel.QueueDeclare(queueName, false, false, false, null);
            channel.QueueBind(queueName, exchangeName, routingKey, null);
            channel.BasicQos(0, 1, false);



            var consumer = new EventingBasicConsumer(channel);

            consumer.Received += (sender, args) =>
            {
                //Task.Delay(TimeSpan.FromSeconds(2)).Wait();
                var body = args.Body.ToArray();
                string message = Encoding.UTF8.GetString(body);

                SendEmail(message);

                Console.WriteLine($"Message received: {message}");

                channel.BasicAck(args.DeliveryTag, false);
            };

            string consumerTag = channel.BasicConsume(queueName, false, consumer);


            channel.BasicCancel(consumerTag);


            channel.Close();
            connection.Close();
        }

        private void SendEmail(string message)
        {
            try
            {
                string smtpServer = "smtp.gmail.com";
                int smtpPort = 587;


                string fromMail = "cdiscoverhs@gmail.com";
                string Password = "ircrhnghicdszqqu";


                var emailData = JsonConvert.DeserializeObject<EmailModel>(message);
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
                    Credentials = new NetworkCredential(fromMail, Password),
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
