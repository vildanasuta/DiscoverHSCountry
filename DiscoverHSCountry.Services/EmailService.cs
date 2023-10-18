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
            try
            {
                var consumer = new EventingBasicConsumer(_channel);
                consumer.Received += (model, ea) =>
                {
                    var body = ea.Body.ToArray();
                    var message = Encoding.UTF8.GetString(body);
                    SendEmail(message);
                    _channel.BasicAck(ea.DeliveryTag, false);
                };
                _channel.QueueDeclare(queue: "email_queue", durable: true, exclusive: false, autoDelete: false, arguments: null);
                _channel.BasicConsume(queue: "email_queue", autoAck: true, consumer: consumer);
            }
            finally
            {
                _channel?.Dispose();
            }
        }

        private void SendEmail(string message)
        {
            try
            {
                var emailData = JsonConvert.DeserializeObject<EmailModel>(message);
                var senderEmail = emailData.Sender;
                var recipientEmail = emailData.Recipient;
                var subject = emailData.Subject;
                var content = emailData.Content;

                string smtpServer = "smtp.gmail.com";
                int smtpPort = 587;

                string smtpUsername = "discoverhscountry@gmail.com";
                string smtpPassword = "yhcsiqdqdefhjzje";

                using (SmtpClient smtpClient = new SmtpClient(smtpServer))
                {
                    smtpClient.Port = smtpPort;
                    smtpClient.Credentials = new NetworkCredential(smtpUsername, smtpPassword);
                    smtpClient.EnableSsl = true;

                    using (MailMessage mailMessage = new MailMessage())
                    {
                        mailMessage.From = new MailAddress(senderEmail);
                        mailMessage.To.Add(recipientEmail);
                        mailMessage.Subject = subject;
                        mailMessage.Body = content;
                        mailMessage.IsBodyHtml = true;

                        smtpClient.Send(mailMessage);
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error sending email: {ex.Message}");
            }
        }
    }
}
