#ifndef WALLETBRIDGE_H
#define WALLETBRIDGE_H

#include <QObject>
#include <QString>
#include <QVariantList>
#include <QVariantMap>

// Forward declare بدل include مباشر عشان نحمي Qt headers من using namespace std
class User;
struct Transaction;

class WalletBridge : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString  username  READ username  NOTIFY userChanged)
    Q_PROPERTY(double   balance   READ balance   NOTIFY userChanged)
    Q_PROPERTY(bool     loggedIn  READ loggedIn  NOTIFY userChanged)
    Q_PROPERTY(QString  message   READ message   NOTIFY messageChanged)

public:
    explicit WalletBridge(QObject* parent = nullptr);
    ~WalletBridge();

    QString username() const;
    double  balance()  const;
    bool    loggedIn() const;
    QString message()  const;

    Q_INVOKABLE void         login(const QString& username, const QString& password);
    Q_INVOKABLE void         logout();
    Q_INVOKABLE bool         deposit(double amount);
    Q_INVOKABLE bool         withdraw(double amount);
    Q_INVOKABLE bool         transfer(const QString& toUsername, double amount);
    Q_INVOKABLE QVariantList getHistory() const;

signals:
    void userChanged();
    void messageChanged();

private:
    User*   m_user;      // pointer بدل object مباشر عشان نتجنب include User.h هنا
    bool    m_loggedIn;
    QString m_message;

    void setMessage(const QString& msg);
};

#endif // WALLETBRIDGE_H