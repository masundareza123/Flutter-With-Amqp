import 'package:flutter_with_amqp/amqp_service.dart';
import 'package:flutter_with_amqp/base_model.dart';

class HomeViewModel extends BaseModel {
  AmqpService _amqpService = AmqpService();

  var valueWatering;
  var valueLampu;
  var pompa;
  var statusTanah;
  bool lampIndicator = false;

  void initState() async {
    subscribeDataWatering();
    setBusy(false);
    subscribeDataLamp();
    setBusy(false);
  }

  void subscribeDataWatering() async {
    setBusy(true);
    _amqpService.subscribe(dataWatering);
    setBusy(false);
  }

  void dataWatering() async {
    setBusy(true);
    _amqpService.dataDevice('watering', setDataWatering);
    setBusy(false);
  }

  void setDataWatering(String message) async {
    valueWatering = int.parse(message);
    if (valueWatering < 350) {
      statusTanah = 'Lembab';
      pompa = 'Off';
    } else if (valueWatering > 700) {
      statusTanah = 'Kering';
      pompa = 'On';
    } else if (valueWatering >= 350 && valueWatering <= 700) {
      statusTanah = 'Normal';
      pompa = 'Off';
    }
    setBusy(false);
  }

  void publishDataLamp(String value) async {
    _amqpService.publish('Lampu', value);
  }

  void subscribeDataLamp() async {
    setBusy(true);
    _amqpService.subscribe(dataLamp);
    setBusy(false);
  }

  void dataLamp() async {
    setBusy(true);
    _amqpService.dataDevice('Lampu', setDataLamp);
    setBusy(false);
  }

  void setDataLamp(String message) async {
    valueLampu = message;
    print(message);
    if (valueLampu == '1') {
      lampIndicator = true;
      setBusy(false);
    } else if (valueLampu == '0') {
      lampIndicator = false;
      setBusy(false);
    }
    setBusy(false);
  }
}
