ALTER TABLE resources
ADD resources_xml XMLTYPE;

UPDATE resources r
SET (resources_xml) = (

SELECT XMLElement("resource",
            XMLElement("date", t.DATERECEIVED),
            XMLElement("type", t.TYPE),
            XMLElement("total", t.TOTAL)
        )
FROM RESOURCES t
WHERE r.RESOURCEID = t.RESOURCEID);