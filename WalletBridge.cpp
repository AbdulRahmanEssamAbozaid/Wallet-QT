#include "WalletBridge.h"
#include "User.h"   // هنا بس — بعيد عن الـ MOC

WalletBridge::WalletBridge(QObject* parent)
    : QObject(parent), m_user(new User()), m_loggedIn(false) {}

WalletBridge::~WalletBridge() {
    delete m_user;
}

// ══════════════════════════════
//         Getters
// ══════════════════════════════
QString WalletBridge::username() const {
    return QString::fromStdString(m_user->GetUsername());
}

double WalletBridge::balance() const {
    return m_user->GetBalance();
}

bool WalletBridge::loggedIn() const {
    return m_loggedIn;
}

QString WalletBridge::message() const {
    return m_message;
}

void WalletBridge::setMessage(const QString& msg) {
    m_message = msg;
    emit messageChanged();
}

// ══════════════════════════════
//         Login / Logout
// ══════════════════════════════
void WalletBridge::login(const QString& username, const QString& password) {
    std::string uname = username.toStdString();
    std::string pwd   = password.toStdString();

    if (!User::userExists(uname)) {
        delete m_user;
        m_user     = new User(User::registerUser(uname, pwd));
        m_loggedIn = true;
        setMessage("Account created! Welcome, " + username + "!");
        emit userChanged();
        return;
    }

    User loaded = User::loadFromFile(uname);
    if (loaded.GetPassword() != pwd) {
        setMessage("Incorrect password. Please try again.");
        return;
    }

    delete m_user;
    m_user     = new User(loaded);
    m_loggedIn = true;
    setMessage("Welcome back, " + username + "!");
    emit userChanged();
}

void WalletBridge::logout() {
    delete m_user;
    m_user     = new User();
    m_loggedIn = false;
    setMessage("");
    emit userChanged();
}

// ══════════════════════════════
//         Transactions
// ══════════════════════════════
bool WalletBridge::deposit(double amount) {
    if (!m_user->deposit(amount)) {
        setMessage("Invalid deposit amount.");
        return false;
    }
    m_user->saveToFile();
    setMessage("Deposited $" + QString::number(amount, 'f', 2) + " successfully.");
    emit userChanged();
    return true;
}

bool WalletBridge::withdraw(double amount) {
    if (!m_user->withdraw(amount)) {
        setMessage("Insufficient balance or invalid amount.");
        return false;
    }
    m_user->saveToFile();
    setMessage("Withdrawn $" + QString::number(amount, 'f', 2) + " successfully.");
    emit userChanged();
    return true;
}

bool WalletBridge::transfer(const QString& toUsername, double amount) {
    std::string toUname = toUsername.toStdString();

    if (!User::userExists(toUname)) {
        setMessage("User '" + toUsername + "' not found.");
        return false;
    }

    User recipient = User::loadFromFile(toUname);
    if (!m_user->transfer(recipient, amount)) {
        setMessage("Insufficient balance or invalid amount.");
        return false;
    }

    recipient.saveToFile();
    m_user->saveToFile();
    setMessage("Transferred $" + QString::number(amount, 'f', 2) + " to " + toUsername + ".");
    emit userChanged();
    return true;
}

// ══════════════════════════════
//         History
// ══════════════════════════════
QVariantList WalletBridge::getHistory() const {
    QVariantList list;
    for (const Transaction& t : m_user->getHistory()) {
        QVariantMap entry;
        entry["type"]   = QString::fromStdString(t.type);
        entry["amount"] = t.amount;
        entry["date"]   = QString::fromStdString(t.date);
        list.append(entry);
    }
    return list;
}