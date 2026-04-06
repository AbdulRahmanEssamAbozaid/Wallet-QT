#ifndef USER_H
#define USER_H

#include <iostream>
#include <string>
#include <vector>

using namespace std;

struct Transaction
{
    string type;
    double amount;
    string date;
};

class User
{
private:
    string username;
    string password;
    double balance;
    vector<Transaction> transactionHistory;

public:
    User() : balance(0.0) {}
    User(const string& uname, const string& pwd) : username(uname), password(pwd), balance(0.0) {}

    string GetUsername() const;
    string GetPassword() const;
    double GetBalance()  const;

    bool deposit(double amount, string date = "N/A");
    bool withdraw(double amount, string date = "N/A");
    bool transfer(User& recipient, double amount, string date = "N/A");
    void DisplayHistory() const;
    const vector<Transaction>& getHistory() const { return transactionHistory; }

    void saveToFile() const;
    static User loadFromFile(const string& targetUsername);
    static bool userExists(const string& targetUsername);
    static User registerUser(const string& username, const string& password);
};


#endif // USER_H
