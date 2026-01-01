CREATE TABLE credit_card_transactions (
    transaction_id     INT PRIMARY KEY,
    transaction_ts     DATETIME,
    card_number        VARCHAR(16),
    merchant_id        VARCHAR(10),
    amount             DECIMAL(10,2),
    currency            VARCHAR(5),
    channel             VARCHAR(20),
    last_updated_ts     DATETIME
);

INSERT INTO credit_card_transactions VALUES
(1,  '2024-09-01 09:05:00', '4111111111111111', 'M001',  500,  'INR', 'POS',           '2024-09-01 09:10:00'),
(2,  '2024-09-01 09:20:00', '4111111111111111', 'M002', 1200,  'INR', 'ONLINE',        '2024-09-01 09:25:00'),
(3,  '2024-09-01 09:45:00', '5222222222222222', 'M003',   75,  'USD', 'INTERNATIONAL', '2024-09-01 09:50:00'),
(4,  '2024-09-01 10:00:00', '4333333333333333', 'M001', 3000,  'INR', 'POS',           '2024-09-01 10:05:00'),
(5,  '2024-09-01 10:15:00', '4111111111111111', 'M004',  900,  'INR', 'ONLINE',        '2024-09-01 10:18:00'),
(6,  '2024-09-01 10:30:00', '5222222222222222', 'M002', 2500,  'INR', 'ONLINE',        '2024-09-01 10:35:00'),
(7,  '2024-09-01 10:45:00', '4333333333333333', 'M003',  120,  'USD', 'INTERNATIONAL', '2024-09-01 10:50:00'),
(8,  '2024-09-01 11:00:00', '4111111111111111', 'M001', 1800,  'INR', 'POS',           '2024-09-01 11:05:00'),
(9,  '2024-09-01 11:20:00', '5222222222222222', 'M004',  200,  'USD', 'INTERNATIONAL', '2024-09-01 11:25:00'),
(10, '2024-09-01 11:40:00', '4333333333333333', 'M002', 1400,  'INR', 'ONLINE',        '2024-09-01 11:45:00'),
(11, '2024-09-01 12:00:00', '4111111111111111', 'M003',   95,  'USD', 'INTERNATIONAL', '2024-09-01 12:05:00'),
(12, '2024-09-01 12:15:00', '5222222222222222', 'M001', 2200,  'INR', 'POS',           '2024-09-01 12:20:00'),
(13, '2024-09-01 12:30:00', '4333333333333333', 'M004', 1600,  'INR', 'ONLINE',        '2024-09-01 12:35:00'),
(14, '2024-09-01 12:45:00', '4111111111111111', 'M002', 3100,  'INR', 'POS',           '2024-09-01 12:50:00'),
(15, '2024-09-01 13:00:00', '5222222222222222', 'M003',  130,  'USD', 'INTERNATIONAL', '2024-09-01 13:05:00');

select * from [dbo].[credit_card_transactions];

CREATE TABLE watermark_control (
    pipeline_name    VARCHAR(50),
    last_watermark   DATETIME
);
INSERT INTO watermark_control (pipeline_name, last_watermark)
VALUES ('credit_card_pipeline', '1900-01-01 00:00:00');

CREATE PROCEDURE update_watermark_table
    @lastmodifytime DATETIME,
    @TableName      VARCHAR(40)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE watermark_control
    SET last_watermark = @lastmodifytime
    WHERE pipeline_name = @TableName;
END;

select * from [dbo].[watermark_control];


INSERT INTO credit_card_transactions VALUES
(16, '2024-09-01 08:40:00', '4111111111111111', 'M001', 700, 'INR', 'POS', '2024-09-02 08:30:00');

INSERT INTO credit_card_transactions VALUES
(17, '2024-09-02 09:10:00', '5222222222222222', 'M002', 1800, 'INR', 'ONLINE', '2024-09-02 09:15:00'),
(18, '2024-09-02 09:45:00', '4333333333333333', 'M003', 110,  'USD', 'INTERNATIONAL', '2024-09-02 09:50:00'),
(19, '2024-09-02 10:20:00', '4111111111111111', 'M004', 1400, 'INR', 'ONLINE', '2024-09-02 10:25:00'),
(20, '2024-09-02 10:50:00', '5222222222222222', 'M001', 2600, 'INR', 'POS', '2024-09-02 10:55:00');


UPDATE credit_card_transactions
SET amount = 2800,
    last_updated_ts = '2024-09-03 09:00:00'
WHERE transaction_id = 4;

INSERT INTO credit_card_transactions VALUES
(21, '2024-09-03 09:20:00', '4333333333333333', 'M002', 2100, 'INR', 'ONLINE', '2024-09-03 09:25:00'),
(22, '2024-09-03 10:00:00', '4111111111111111', 'M003', 85,   'USD', 'INTERNATIONAL', '2024-09-03 10:05:00'),
(23, '2024-09-03 10:40:00', '5222222222222222', 'M004', 1900, 'INR', 'ONLINE', '2024-09-03 10:45:00');

DELETE FROM credit_card_transactions;

delete from [dbo].[watermark_control] where last_watermark='2024-09-03 10:45:00';


