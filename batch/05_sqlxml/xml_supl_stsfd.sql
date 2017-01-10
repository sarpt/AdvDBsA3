ALTER TABLE supplier
ADD supl_stsfd XMLTYPE;

UPDATE supplier s
SET (supl_stsfd) = (

SELECT XMLElement("supplier", 
            XMLAttributes(sup.SUPPLIERID AS "supid",
                        sup.TITLE AS "title"
            ),
            XMLAgg(XMLElement("supply", 
                        XMLAttributes(sr.REQUESTID AS "reqid",
                                    sr.DATEREQUEST AS "date-request",
                                    sr.STATE AS "state"
                        )
                    )
            )
        )
FROM supply_request sr
INNER JOIN supplier_stock supst
ON sr.INGRSTOCKID = supst.INGRSTOCKID
INNER JOIN supplier sup
ON sup.SUPPLIERID = supst.SUPPLIERID
WHERE s.SUPPLIERID = sup.SUPPLIERID
GROUP BY sup.SUPPLIERID, sup.TITLE);