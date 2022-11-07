import 'package:dart_amqp/dart_amqp.dart';

class AmqpService{
  late Client client;

  void publish(String queue,String message) {
    ConnectionSettings settings = ConnectionSettings(
        host: 'rmq2.pptik.id',
        authProvider: PlainAuthenticator('smkn13bandung', 'qwerty'),
        virtualHost: '/smkn13bandung'
    );
    Client client = Client(settings: settings);
    client.channel().then((Channel channel) async {
      return channel.queue(queue, durable: true);
    }).then((Queue queue){
      queue.publish(message);
      client.close();
    });

  }

  void subscribe(Function sensor){
    ConnectionSettings settings = ConnectionSettings(
        host: 'rmq2.pptik.id',
        authProvider: PlainAuthenticator('smkn13bandung', 'qwerty'),
        virtualHost: '/smkn13bandung'
    );
    client = Client(settings: settings);
    client.connect().then((value) {
      print('[Subscribe Data] $settings');
      sensor();
    });
  }

  void dataDevice(String queueRmq, Function value){
    client
        .channel()
        .then((Channel channel) => channel.queue(queueRmq, durable: true))
        .then((Queue queue) => queue.consume())
        .then((Consumer consumer) => consumer.listen((AmqpMessage message){
      value(message.payloadAsString);
    }));
  }
}