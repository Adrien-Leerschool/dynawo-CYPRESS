<!--  This xsl:
    * add missing parameters for generators: PNomTurb, PNomAlt, Tppq0, XppqPu, UsRefMaxPu, UsRefMinPu
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dyn="http://www.rte-france.com/dynawo">
<xsl:output method='xml' version='1.0' encoding='UTF-8' indent='yes'/>

<!--  These lines enable to avoid empty lines after removing some elements while keeping the indentation fine -->
<xsl:strip-space elements="*"/>

<!--  This first template copies all the xml. It will be overrided by the following templates when they could be applied -->
<xsl:template match="@*|node()">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()"/>
  </xsl:copy>
</xsl:template>

<!--  To deal with file containing dynawo namespace -->
<!--  We go through all the par entries of each set: <par type="" ... />
        * If the par name corresponds to one of the rule on names, we apply a treatment. Otherwise we just copy the par.
        * For PMinPu, QMinPu and QMaxPu, it is quite simple: we multiply by 100.
        * For PMaxPu, we use it to create PNom and if necessary SNom. It is also modified and multiplied by 100.
        * For AlphaPu and LambdaPu, we replace it by a new attribute AlphaPuPNom or LambdaPuSNom and use the value of PMaxPu to calculate it.
          (we go back to the set and then comes back to PMaxPu to be sure that we take the PMaxPu from the set and not the first PMaxPu of the file.
 -->
<xsl:template match="dyn:par">
  <xsl:choose>
    <xsl:when test="@name='generator_PNom'">
      <xsl:element name="par" xmlns="http://www.rte-france.com/dynawo">
        <xsl:attribute name="type">DOUBLE</xsl:attribute>
        <xsl:attribute name="name">generator_PNomTurb</xsl:attribute>
        <xsl:attribute name="value"><xsl:value-of select="@value"/></xsl:attribute>
      </xsl:element>
      <xsl:element name="par" xmlns="http://www.rte-france.com/dynawo">
        <xsl:attribute name="type">DOUBLE</xsl:attribute>
        <xsl:attribute name="name">generator_PNomAlt</xsl:attribute>
        <xsl:attribute name="value"><xsl:value-of select="@value"/></xsl:attribute>
      </xsl:element>
    </xsl:when>
    <xsl:when test="@name='generator_Tpq0'and not(../dyn:par[@name='generator_XppqPu'])">
      <xsl:element name="par" xmlns="http://www.rte-france.com/dynawo">
        <xsl:attribute name="type">DOUBLE</xsl:attribute>
        <xsl:attribute name="name">generator_Tppq0</xsl:attribute>
        <xsl:attribute name="value"><xsl:value-of select="@value"/></xsl:attribute>
      </xsl:element>
    </xsl:when>
    <xsl:when test="@name='generator_XpqPu'and not(../dyn:par[@name='generator_XppqPu'])">
      <xsl:element name="par" xmlns="http://www.rte-france.com/dynawo">
        <xsl:attribute name="type">DOUBLE</xsl:attribute>
        <xsl:attribute name="name">generator_XppqPu</xsl:attribute>
        <xsl:attribute name="value"><xsl:value-of select="@value"/></xsl:attribute>
      </xsl:element>
    </xsl:when>
    <xsl:when test="@name='voltageRegulator_EfdMaxPu'and not(../dyn:par[@name='voltageRegulator_UsRefMaxPu'])">
      <xsl:copy-of select="."/>
      <xsl:element name="par" xmlns="http://www.rte-france.com/dynawo">
        <xsl:attribute name="type">DOUBLE</xsl:attribute>
        <xsl:attribute name="name">voltageRegulator_UsRefMaxPu</xsl:attribute>
        <xsl:attribute name="value">1.2</xsl:attribute>
      </xsl:element>
    </xsl:when>
    <xsl:when test="@name='voltageRegulator_EfdMaxPu'and not(../dyn:par[@name='voltageRegulator_UsRefMinPu'])">
      <xsl:copy-of select="."/>
      <xsl:element name="par" xmlns="http://www.rte-france.com/dynawo">
        <xsl:attribute name="type">DOUBLE</xsl:attribute>
        <xsl:attribute name="name">voltageRegulator_UsRefMinPu</xsl:attribute>
        <xsl:attribute name="value">0.8</xsl:attribute>
      </xsl:element>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy-of select="."/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!--  To deal with file without namespace-->
<xsl:template match="par">
  <xsl:choose>
    <xsl:when test="@name='generator_PNom'">
      <xsl:element name="par">
        <xsl:attribute name="type">DOUBLE</xsl:attribute>
        <xsl:attribute name="name">generator_PNomTurb</xsl:attribute>
        <xsl:attribute name="value"><xsl:value-of select="@value"/></xsl:attribute>
      </xsl:element>
      <xsl:element name="par">
        <xsl:attribute name="type">DOUBLE</xsl:attribute>
        <xsl:attribute name="name">generator_PNomAlt</xsl:attribute>
        <xsl:attribute name="value"><xsl:value-of select="@value"/></xsl:attribute>
      </xsl:element>
    </xsl:when>
    <xsl:when test="@name='generator_XpqPu'and not(../par[@name='generator_XppqPu'])">
      <xsl:element name="par">
        <xsl:attribute name="type">DOUBLE</xsl:attribute>
        <xsl:attribute name="name">generator_XppqPu</xsl:attribute>
        <xsl:attribute name="value"><xsl:value-of select="@value"/></xsl:attribute>
      </xsl:element>
    </xsl:when>
    <xsl:when test="@name='generator_Tpq0'and not(../par[@name='generator_XppqPu'])">
      <xsl:element name="par">
        <xsl:attribute name="type">DOUBLE</xsl:attribute>
        <xsl:attribute name="name">generator_Tppq0</xsl:attribute>
        <xsl:attribute name="value"><xsl:value-of select="@value"/></xsl:attribute>
      </xsl:element>
    </xsl:when>
    <xsl:when test="@name='voltageRegulator_EfdMaxPu'and not(../dyn:par[@name='voltageRegulator_UsRefMaxPu'])">
      <xsl:copy-of select="."/>
      <xsl:element name="par">
        <xsl:attribute name="type">DOUBLE</xsl:attribute>
        <xsl:attribute name="name">voltageRegulator_UsRefMaxPu</xsl:attribute>
        <xsl:attribute name="value">1.2</xsl:attribute>
      </xsl:element>
    </xsl:when>
    <xsl:when test="@name='voltageRegulator_EfdMaxPu'and not(../dyn:par[@name='voltageRegulator_UsRefMinPu'])">
      <xsl:copy-of select="."/>
      <xsl:element name="par">
        <xsl:attribute name="type">DOUBLE</xsl:attribute>
        <xsl:attribute name="name">voltageRegulator_UsRefMinPu</xsl:attribute>
        <xsl:attribute name="value">0.8</xsl:attribute>
      </xsl:element>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy-of select="."/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
