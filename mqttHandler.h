#ifndef MQTTHANDLER_H
#define MQTTHANDLER_H

#include <QObject>
#include <QMqttClient>
#include <QDebug>
class MqttHandler: public QObject
{
    Q_OBJECT
public:
    explicit MqttHandler(QObject* parent = nullptr,
                const char* hostName = nullptr,
                uint16_t port = 1880,
                const char* userName = nullptr,
                const char* password = nullptr
    );
    ~MqttHandler();

    void onConnected();
    void onMessageRecieved(const QByteArray &message, const QMqttTopicName &topic);
    void onSubcribed(QMqttSubscription::SubscriptionState state);

    void addTopic(const char* topicName);
    void addTopicList(const char** topicNameList, const int &size);


private:
    QStringList topics;
    QMqttClient* client = nullptr;




};

#endif // MQTTHANDLER_H
