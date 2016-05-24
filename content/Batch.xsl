<?xml version="1.0" encoding="ISO-8859-1"?><xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" >
<xsl:template match="/">
    <html>
        <head>
            <title>Batch Summary</title>
            <style type="text/css">
            @import url(../../../../../content/Batch.css);
            </style>
        </head>
    <body>
        <div id="heading">
            <h1>Batch <xsl:value-of select="batch/run/batch_name"/>
                [<xsl:value-of select="count(batch/run/total_run_time)"/> items]
            </h1>
            <br />
            <h2>
                <xsl:variable name="href">./Summary.xml</xsl:variable>
                <a href="{$href}"> <xsl:value-of select="batch/run/environment"/> Summary</a> -> Batch Summary
            </h2>
        </div>

		<xsl:variable name="corrupt_status">
			<xsl:for-each select="batch/run/status[contains(.,'CORRUPT')]">
				<xsl:if test="position()=1">
					<xsl:copy-of select="."/>
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>


        <table>
            <tr class="header_row">
                <th>Run</th>
                <th>Folder</th>
                <th>Test name</th>
                <th>Target</th>
                <th>Started</th>
                <th>Ended</th>
                <th>Duration</th>
                <th>Steps Run</th>
                <th>Failed Steps</th>
            </tr>

            <xsl:for-each select="batch/run">
                <tr>
                <xsl:variable name="href">../<xsl:value-of select="test_parent_folder"/>/<xsl:value-of select="test_name"/>/results_<xsl:value-of select="run_number"/>/results_<xsl:value-of select="run_number"/></xsl:variable>
                <xsl:variable name="pending_href">../<xsl:value-of select="test_parent_folder"/>/<xsl:value-of select="test_name"/>/results_<xsl:value-of select="run_number"/>/webinject_stdout</xsl:variable>
                    <xsl:choose>
                        <xsl:when test="end_time='PENDING'">
                            <td> <a class="pend" href="{$pending_href}.txt"> <xsl:value-of select="run_number"/></a> </td>
                        </xsl:when>
                        <xsl:otherwise>
                            <td> <a class="link_number" href="{$href}.xml"> <xsl:value-of select="run_number"/></a> </td>
                        </xsl:otherwise>
                    </xsl:choose>
                    <td> <xsl:value-of select="test_parent_folder"/> </td>
                    <xsl:variable name="wif_stdout">../<xsl:value-of select="test_parent_folder"/>/<xsl:value-of select="test_name"/>/results_<xsl:value-of select="run_number"/>/wif_stdout.txt</xsl:variable>
                    <td><a href="{$wif_stdout}"> <xsl:value-of select="test_name"/> </a></td>
                    <td> <xsl:value-of select="target"/> </td>
                    <td> <xsl:value-of select="translate(start_date_time,'T',' ')"/> </td>
                    <xsl:variable name="wi_stdout">../<xsl:value-of select="test_parent_folder"/>/<xsl:value-of select="test_name"/>/results_<xsl:value-of select="run_number"/>/webinject_stdout.txt</xsl:variable>
                    <xsl:choose>
                        <xsl:when test="end_time='PENDING'">
                            <td class="pend"> <xsl:text> PENDING </xsl:text> </td>
                            <td class="pend"> <xsl:text> 0 </xsl:text> </td>
                            <td class="pend"> <xsl:text> 0 </xsl:text> </td>
                            <td class="pend"> <xsl:text> 0 </xsl:text> </td>
                        </xsl:when>
                        <xsl:otherwise>
                            <td> <xsl:value-of select="translate(end_time,'T',' ')"/> </td>
                            <td> <xsl:value-of select="total_run_time"/> </td>
                            <td> <a href="{$wi_stdout}"> <xsl:value-of select="test_steps_run"/> </a></td>
                            <xsl:choose>
                                <xsl:when test="status='NORMAL'">
                                    <xsl:choose>
                                        <xsl:when test="test_steps_failed>0">
                                            <xsl:choose>
                                                <xsl:when test="sanity_check_passed='true'">
                                                    <td class="fail"> <xsl:value-of select="test_steps_failed"/> &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; :-(</td>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <td class="sanity"> <xsl:value-of select="test_steps_failed"/> <xsl:text> sanity fail &#160;&#160; O.o</xsl:text> </td>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:when>
                                        <xsl:when test="test_steps_failed=0">
                                            <td class="pass"> <xsl:value-of select="test_steps_failed"/> </td>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <td class="fail"> <xsl:value-of select="test_steps_failed"/> </td>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>
                                <xsl:otherwise>
                                    <td class="corrupt">xml corrupt &#160;&#160; :-/</td>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:otherwise>
                    </xsl:choose>
                </tr>
            </xsl:for-each>

		    <xsl:variable name="mindate">
			    <xsl:for-each select="batch/run/start_date_time">
				    <xsl:sort order="ascending"/>
				    <xsl:if test="position()=1">
					    <xsl:copy-of select="."/>
				    </xsl:if>
			    </xsl:for-each>
		    </xsl:variable>
		    <xsl:variable name="maxdate">
			    <xsl:for-each select="batch/run/end_time">
				    <xsl:sort order="descending"/>
				    <xsl:if test="position()=1">
					    <xsl:copy-of select="."/>
				    </xsl:if>
			    </xsl:for-each>
		    </xsl:variable>
    
            <tr class="footer_row">
                <td colspan="4"> </td>
		        <th><xsl:value-of select="translate($mindate,'T',' ')"/></th>
		        <th><xsl:value-of select="translate($maxdate,'T',' ')"/></th>
                <th align="left"><xsl:value-of select="format-number(sum(batch/run/total_run_time), '#.0')"/></th>
                <th align="left"><xsl:value-of select="sum(batch/run/test_steps_run)"/></th>
                <xsl:choose>
                    <xsl:when test="not($corrupt_status='CORRUPT')">
           	            <xsl:choose>
                            <xsl:when test="sum(batch/run/test_steps_failed)>0">
                                <th class="fail"> <xsl:value-of select="sum(batch/run/test_steps_failed)"/> </th>
                            </xsl:when>
                            <xsl:when test="sum(batch/run/test_steps_failed)=0">
                                <th class="pass"> <xsl:value-of select="sum(batch/run/test_steps_failed)"/> </th>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <td class="corrupt"> xml corruption </td>
                    </xsl:otherwise>
                </xsl:choose>
             </tr>
        </table>

		<xsl:variable name="lastfails">
			<xsl:for-each select="batch/run/end_time[not(contains(.,'PENDING'))]">
				<xsl:sort order="descending"/>
				<xsl:if test="position()=1">
					<xsl:copy-of select="ancestor::run/test_steps_failed[1]"/>
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>

        <xsl:comment>
            <xsl:value-of select="$lastfails"/> failures for most recently finished test
        </xsl:comment>

         <!--Specifying the datatype for the sort is critical!! -->
        <xsl:comment>
    		<xsl:variable name="mintime">
    			<xsl:for-each select="batch/run/start_seconds">
    				<xsl:sort data-type="number" order="ascending"/>
    				<xsl:if test="position()=1">
    					<xsl:copy-of select="."/>
    				</xsl:if>
    			</xsl:for-each>
    		</xsl:variable>
    		<xsl:variable name="maxtime">
    			<xsl:for-each select="batch/run/end_seconds">
    				<xsl:sort data-type="number" order="descending"/>
    				<xsl:if test="position()=1">
    					<xsl:copy-of select="."/>
    				</xsl:if>
    			</xsl:for-each>
    		</xsl:variable>

            <h3>Batch Elapsed Time</h3>
    		<xsl:value-of select="number($maxtime)-number($mintime)"/> seconds / 
    		<xsl:value-of select='round(10*(number($maxtime)-number($mintime)) div 60) div 10'/> minutes 
        </xsl:comment>

    </body>
    </html>
</xsl:template></xsl:stylesheet>