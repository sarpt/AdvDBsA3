ALTER TABLE supply_request
ADD ingr_sr XMLTYPE;

UPDATE supply_request s
SET (ingr_sr) = (
SELECT XMLElement("ingredient", 
            XMLAttributes(t1.INGRSTOCKID AS "ingrid",
                        t2.TITLE AS "title"
            ),
            XMLAgg(XMLElement("supply", 
                        XMLAttributes(t1.REQUESTID AS "reqid",
                                    t1.DATEREQUEST AS "date-request",
                                    t1.STATE AS "state"
                        )
                    )
            )
        )
FROM supply_request t1
INNER JOIN ingredient_stock t2
ON t1.INGRSTOCKID = t2.INGRSTOCKID
WHERE s.INGRSTOCKID = t1.INGRSTOCKID
GROUP BY t1.INGRSTOCKID, t2.TITLE);