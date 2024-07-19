#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "dashboardController.h"
#include "videoController.h"

#include<QtMultimedia/qmediaplayer.h>
int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    // fist solution: load c++ object to qml file and use, you need add marcro QML_ELEMEMT on constructor of your object
    qmlRegisterType<DashboardController>("DashboardController", 1, 0, "DashboardController");
    // second solution: create c++ object and offer its context for the qml engine(it manager all qml), next just use c++ object on qml file
    DashboardController* dashboardController =  new DashboardController(&app,"/dev/ttyUSB0",9600);
    engine.rootContext()->setContextProperty("DashboardController", dashboardController);

    VideoController* videoController =  new VideoController(&app,"io.adafruit.com",1883,"NhanHuynh", "");
    engine.rootContext()->setContextProperty("VideoController", videoController);


    const QUrl url(QStringLiteral("qrc:/smartpole_screen/Main.qml"));
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.load(url);



    return app.exec();




}
