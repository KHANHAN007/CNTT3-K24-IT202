DROP DATABASE tonghop;
CREATE DATABASE tonghop;

USE tonghop;

CREATE TABLE Customer (
    customer_id VARCHAR(20) PRIMARY KEY,
    full_name   VARCHAR(100) NOT NULL,
    national_id VARCHAR(20)  NOT NULL UNIQUE,
    phone       VARCHAR(15)  NOT NULL UNIQUE,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Account (
    account_id   VARCHAR(20) PRIMARY KEY,
    customer_id  VARCHAR(20) NOT NULL,
    balance      DECIMAL(15,2) NOT NULL DEFAULT 0,

    CONSTRAINT chk_balance
        CHECK (balance >= 0),

    CONSTRAINT fk_account_customer
        FOREIGN KEY (customer_id)
        REFERENCES Customer(customer_id)
);

CREATE TABLE Partner (
    partner_id   VARCHAR(20) PRIMARY KEY,
    partner_name VARCHAR(100) NOT NULL UNIQUE,
    created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE TuitionBill (
    bill_id      VARCHAR(20) PRIMARY KEY,
    partner_id   VARCHAR(20) NOT NULL,
    student_name VARCHAR(100) NOT NULL,
    amount       DECIMAL(15,2) NOT NULL,
    bill_status  VARCHAR(20) NOT NULL DEFAULT 'Unpaid',
    created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_bill_amount
        CHECK (amount > 0),

    CONSTRAINT fk_bill_partner
        FOREIGN KEY (partner_id)
        REFERENCES Partner(partner_id)
);

CREATE TABLE TransactionHistory (
    transaction_id VARCHAR(20) PRIMARY KEY,
    account_id     VARCHAR(20) NOT NULL,
    bill_id        VARCHAR(20) NOT NULL UNIQUE,
    amount         DECIMAL(15,2) NOT NULL,
    transaction_status VARCHAR(20) NOT NULL DEFAULT 'Pending',
    created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_transaction_amount
        CHECK (amount > 0),

    CONSTRAINT fk_transaction_account
        FOREIGN KEY (account_id)
        REFERENCES Account(account_id),

    CONSTRAINT fk_transaction_bill
        FOREIGN KEY (bill_id)
        REFERENCES TuitionBill(bill_id)
);