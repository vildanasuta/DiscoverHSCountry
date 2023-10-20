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

            //sender
            ConnectionFactory factory = new ConnectionFactory();

            // for docker: 
            var uriString = "amqp://guest:guest@host.docker.internal:5672";
            /* locally: var uriString = "amqp://guest:guest@localhost:5672";*/


            factory.Uri = new Uri(uriString);
            factory.ClientProvidedName = "Rabbit Test";

            IConnection connection = factory.CreateConnection();
            IModel channel = connection.CreateModel();

            string exchangeName = "EmailExchange";
            string routingKey = "email_queue";
            string queueName = "EmailQueue";

            channel.ExchangeDeclare(exchangeName, ExchangeType.Direct);
            channel.QueueDeclare(queueName, false, false, false, null);
            channel.QueueBind(queueName, exchangeName, routingKey, null);

            string emailModelJson = JsonConvert.SerializeObject(emailModel);
            byte[] messageBodyBytes = Encoding.UTF8.GetBytes(emailModelJson);
            channel.BasicPublish(exchangeName, routingKey, null, messageBodyBytes);
            //Thread.Sleep(TimeSpan.FromSeconds(1));

            channel.Close();
            connection.Close();
        }
    }

}
