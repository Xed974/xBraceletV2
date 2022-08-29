ALTER TABLE `users`
  ADD `bracelet` int(1) NOT NULL DEFAULT 0;
COMMIT;

INSERT INTO `items` (name, label) VALUES
    ('pince', 'Pince');

--- Xed#1188