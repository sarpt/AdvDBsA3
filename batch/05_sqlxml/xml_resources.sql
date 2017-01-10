SELECT XMLElement("resource",
            XMLElement("date", t.DATERECEIVED),
            XMLElement("type", t.TYPE),
            XMLElement("total", t.TOTAL)
        )
FROM RESOURCES t