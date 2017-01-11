BEGIN
  DBMS_XMLSCHEMA.registerSchema(
    SCHEMAURL => 'http://xmlns.oracle.com/xdb/documentation/resources.xsd',
    SCHEMADOC => '
    <xs:schema 
    targetNamespace="http://xmlns.oracle.com/xdb/documentation/resources.xsd"
    xmlns:xsr="http://xmlns.oracle.com/xdb/documentation/resources.xsd"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" version="1.0">
    
      <!-- resource type enum -->
      <!-- begin -->
      <xs:simpleType name="resType">
        <xs:restriction base="xs:string">
          <xs:enumeration value="PAYMENT"/>
          <xs:enumeration value="INVESTMENT"/>
          <xs:enumeration value="TRANSFER"/>
        </xs:restriction>
      </xs:simpleType>
      <!-- end -->
    
      <!-- resource-->
      <!-- begin -->
      <xs:complexType name="resource">
        <xs:sequence>
          <xs:element name="type" type="xsr:resType"/>
          <xs:element name="datereceived" type="xs:date"/>
          <xs:element name="total" type="xs:positiveInteger"/>
        </xs:sequence>
      </xs:complexType>
      <!-- end -->
    
    </xs:schema>
    '
  );
END;
/

ALTER TABLE resources
ADD resources_xml CLOB;

UPDATE resources r
SET (resources_xml) = (
SELECT XMLSerialize(DOCUMENT XMLElement("resource",
            XMLAttributes('http://www.w3.org/2001/XMLschema' AS "xmlns:xs",
                          'http://xmlns.oracle.com/xdb/documentation/resources.xsd' AS "xs:xsr"),
            XMLForest(t.TYPE, t.DATERECEIVED, t.TOTAL)
        ))
FROM RESOURCES t
WHERE r.RESOURCEID = t.RESOURCEID);