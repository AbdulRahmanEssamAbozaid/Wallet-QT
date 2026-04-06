#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "WalletBridge.h"

int main(int argc, char* argv[])
{
    QGuiApplication app(argc, argv);
    app.setApplicationName("Wallet App");

    WalletBridge bridge;

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("wallet", &bridge);

    // NO_RESOURCE_TARGET_PATH → الملفات على qrc:/ مباشرة
    const QUrl url(QStringLiteral("qrc:/Main.qml"));

    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);

    engine.load(url);
    return app.exec();
}
