#ifndef VIDEOCONTROLLER_H
#define VIDEOCONTROLLER_H

#include <QObject>
#include <QMqttClient>
#include <QDebug>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QJsonValue>



class VideoController: public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString link READ getLink WRITE setLink NOTIFY LinkChanged FINAL)
public:
    explicit VideoController(QObject* parent = nullptr,
                const char* hostName = nullptr,
                uint16_t port = 1880,
                const char* userName = nullptr,
                const char* password = nullptr
    );
    ~VideoController();

    void onConnected();
    void onMessageRecieved(const QByteArray &message, const QMqttTopicName &topic);
    // void onSubcribed(QMqttSubscription::SubscriptionState state);
    void subscribeAllTopic();




    void addTopic(const char* topicName);
    void addSubcriptionPointer(QMqttSubscription* newSubcription);
    void addTopicList(const char** topicNameList, const int &size);


    void clearSubscriptionsManager();


    QString getLink() const;
    void setLink(const QString &newLink);
    void setLink(const char* newLink);
    QString  getLastLink();


signals:
    void LinkChanged();

private:
    QList<QMqttTopicFilter> topics;
    QList<QMqttSubscription*> subcriptionsManager;
    QMqttClient* client = nullptr;
    char* defaultLink = "file:///home/nhan/workspace/img/wave.mp4";
    QString m_link;
};

#endif // VIDEOCONTROLLER_H
