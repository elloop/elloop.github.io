#About Code

##utf8

##utf8mb4

10.1.10.6 The utf8mb4 Character Set (4-Byte UTF-8 Unicode Encoding)

The character set named utf8 uses a maximum of three bytes per character and contains only BMP characters. As of MySQL 5.5.3, the utf8mb4 character set uses a maximum of four bytes per character supports supplemental characters:

    For a BMP character, utf8 and utf8mb4 have identical storage characteristics: same code values, same encoding, same length.

    For a supplementary character, utf8 cannot store the character at all, while utf8mb4 requires four bytes to store it. Since utf8 cannot store the character at all, you do not have any supplementary characters in utf8 columns and you need not worry about converting characters or losing data when upgrading utf8 data from older versions of MySQL. 

utf8mb4 is a superset of utf8, so for an operation such as the following concatenation, the result has character set utf8mb4 and the collation of utf8mb4_col:

SELECT CONCAT(utf8_col, utf8mb4_col);

Similarly, the following comparison in the WHERE clause works according to the collation of utf8mb4_col:

SELECT * FROM utf8_tbl, utf8mb4_tbl
WHERE utf8_tbl.utf8_col = utf8mb4_tbl.utf8mb4_col;

Tip: To save space with UTF-8, use VARCHAR instead of CHAR. Otherwise, MySQL must reserve three (or four) bytes for each character in a CHAR CHARACTER SET utf8 (or utf8mb4) column because that is the maximum possible length. For example, MySQL must reserve 40 bytes for a CHAR(10) CHARACTER SET utf8mb4 column. 
