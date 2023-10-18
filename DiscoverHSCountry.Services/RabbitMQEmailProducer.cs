using Newtonsoft.Json;
using RabbitMQ.Client;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Channels;
using System.Threading.Tasks;

namespace DiscoverHSCountry.Services
{
    public class EmailModel
    {
        public string Sender { get; set; }
        public string Recipient { get; set; }
        public string Subject { get; set; }
        public string Content { get; set; }
    }

    public class RabbitMQEmailProducer: IDisposable
    {
        private readonly IModel _channel;

        public RabbitMQEmailProducer(IModel channel)
        {
            _channel = channel;
        }

        public void Dispose()
        {
            _channel?.Dispose();
        }

        public void SendConfirmationEmail(EmailModel emailModel)
        {
                var messageBody = JsonConvert.SerializeObject(emailModel);
                var body = Encoding.UTF8.GetBytes(messageBody);
                _channel.QueueDeclare(queue: "email_queue", durable: true, exclusive: false, autoDelete: false, arguments: null);
                _channel.BasicPublish(exchange: "", routingKey: "email_queue", basicProperties: null, body: body);
 
        }
    }

}
