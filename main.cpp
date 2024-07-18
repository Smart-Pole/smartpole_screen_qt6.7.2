#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "serialObserver.h"
#include "mqttHandler.h"
int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    qmlRegisterType<SerialObserver>("SerialObserver", 1, 0, "SerialObserver");
    const QUrl url(QStringLiteral("qrc:/smartpole_screen/Main.qml"));
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.load(url);
    // Serial usb = Serial();


    return app.exec();




}
