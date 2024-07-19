#include "videoController.h"



VideoController::VideoController(QObject *parent, const char *hostName, const uint16_t port, const char *userName, const char* password):
    QObject( parent ),
    client( new QMqttClient(this))
{
    client->setHostname(QString(hostName));
    client->setPort(quint16(port));
    client->setUsername(QString(userName));
    client->setPassword(QString(password));


    connect(client,&QMqttClient::connected,this,&VideoController::onConnected);
    connect(client,&QMqttClient::messageReceived,this,&VideoController::onMessageRecieved);
    connect(client,&QMqttClient::errorChanged,this, [](QMqttClient::ClientError error) {
        qDebug()<<"[Error] "<< error << "\n";}
    );



    client->connectToHost();
    // subscribe topic


}

VideoController::~VideoController(){
    qDebug()<< "MQTT Deleted \n";
    delete client;
    clearSubscriptionsManager();
}




void VideoController::onConnected()
{
    qDebug()<< "[Connection] Connect successfull \n";
    // QMqttTopicFilter myTopic("NhanHuynh/feeds/led");
    // QMqttSubscription* subscription = client->subscribe(myTopic, 0);
    subscribeAllTopic();

}

void VideoController::onMessageRecieved(const QByteArray &message, const QMqttTopicName &topic)
{
    qDebug()<<"[Recieve]:[from: "<< topic <<"]:[Data: "<< message <<"] \n";
    //json format {"ID": [1, 2, 3], "link":"file:///home/nhan/workspace/img/wave.mp4"}
    // or {"ID": [1, 2, 3], "link":"file:///home/nhan/workspace/img/sea.mp4"}

    QJsonDocument messageJsonDoc = QJsonDocument::fromJson(message);
    if (messageJsonDoc.isObject()) {
        // convert document to Oject
        QJsonObject messageJsonObj = messageJsonDoc.object();
        // Get json value from key
        QJsonValue recievedIDList = messageJsonObj["ID"];
        QJsonValue recievedLink = messageJsonObj["link"];
        // Convert type from json to appropriated value
        QJsonArray IDList = recievedIDList.toArray();
        QString link = recievedLink.toString();
        setLink(link);
        qDebug()<<messageJsonObj;
        qDebug()<<recievedIDList.toArray();
        qDebug()<<link;
    }
    else{
        qWarning() << "[Warning] data recieved is not json \n" ;
    }
}

void VideoController::subscribeAllTopic()
{
    foreach(const QMqttTopicFilter &topic, topics){
        QMqttTopicFilter newTopic(topic);
        QMqttSubscription* subscription = client->subscribe(newTopic, 0);
        if (subscription != nullptr) {
            qDebug() << "[Subcription] Subscribed to topic:" << topic.filter();
            addSubcriptionPointer(subscription);

        } else {
            qWarning() << "[Warning] Failed to subscribe to topic: " << topic.filter();
        }

    }
}



void VideoController::addSubcriptionPointer(QMqttSubscription *newSubcription)
{
    subcriptionsManager.append(newSubcription);
}


void VideoController::clearSubscriptionsManager()
{
    foreach(const QMqttSubscription* item, subcriptionsManager){
        delete item;
    }
}


void VideoController::addTopic(const char *topicName)
{
    if(topicName != nullptr){
        topics.append(QMqttTopicFilter(topicName));
    }
}



void VideoController::addTopicList(const char **topicNameList,const int &size)
{
    if(topicNameList != nullptr){
        for(int i = 0; i < size; ++i){
            addTopic(topicNameList[i]);
        }
    }
}


QString VideoController::getLink() const
{
    return m_link;
}

void VideoController::setLink(const QString &newLink)
{
    if (m_link == newLink)
        return;
    m_link = newLink;
    emit LinkChanged();
}

void VideoController::setLink(const char* newLink)
{
    QString newQString(newLink);
    if (m_link == newQString)
        return;
    m_link = newQString;
    emit LinkChanged();
}
