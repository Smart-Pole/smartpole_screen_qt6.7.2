#include "mqttHandler.h"



MqttHandler::MqttHandler(QObject *parent, const char *hostName, const uint16_t port, const char *userName, const char* password):
    QObject( parent ),
    client( new QMqttClient(this))
{
    client->setHostname(QString(hostName));
    client->setPort(quint16(port));
    client->setUsername(QString(userName));
    client->setPassword(QString(password));





    connect(client,&QMqttClient::connected,this,&MqttHandler::onConnected);
    connect(client,&QMqttClient::messageReceived,this,&MqttHandler::onMessageRecieved);
    connect(client,&QMqttClient::errorChanged,this, [this](QMqttClient::ClientError error) { qDebug()<<"[Error:] "<< error << "\n";});
    connect(client,&QMqttClient::authenticationRequested,this, [this](const QMqttAuthenticationProperties &p) { qDebug()<<"[Error:] "<< p.authenticationMethod()<< "\n";});
    connect(client,&QMqttClient::authenticationFinished,this, [this](const QMqttAuthenticationProperties &p) { qDebug()<<"[Error:] "<< p.authenticationMethod()<< "\n";});
    client->connectToHost();
    // subscribe topic


}

MqttHandler::~MqttHandler(){
    qDebug()<< "MQTT Deleted \n";
    delete client;
}
void MqttHandler::onConnected()
{
    qDebug()<< "Connect successfull \n";
    QMqttTopicFilter myTopic("NhanHuynh/feeds/led");
    // myTopic.setFilter("NhanHuynh/feeds/led");
    QMqttSubscription* subscription = client->subscribe(myTopic, 0);

    // qDebug()<< "[Subscription state]: " << subscription->state();

    if (subscription!=nullptr) {
        qDebug() << "Subscribed to topic:" << subscription->state();

    } else {
        qWarning() << "Failed to subscribe to topic";
    }

}

void MqttHandler::onMessageRecieved(const QByteArray &message, const QMqttTopicName &topic)
{
    qDebug()<<"[Recieve]:[from: "<< topic <<"]:[Data: "<< message <<"] \n";
}

void MqttHandler::onSubcribed(QMqttSubscription::SubscriptionState state)
{
    qDebug()<<"[State subcribed:]" << state;
}




void MqttHandler::addTopic(const char *topicName)
{
    if(topicName != nullptr){
        topics.append(QString(topicName));
    }
}

void MqttHandler::addTopicList(const char **topicNameList,const int &size)
{
    if(topicNameList != nullptr){
        for(int i = 0; i < size; ++i){
            addTopic(topicNameList[i]);
        }
    }
}


