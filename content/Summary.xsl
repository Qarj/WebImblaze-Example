<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="/">
<html>
  <head>
    <title>Overall Summary</title>
    <style type="text/css">
    @import url(/content/Summary.css);
    </style>
	<script type="text/javascript" src="/scripts/jquery-2.2.3.min.js"></script>
	<script type="text/javascript">
<![CDATA[
    $(document).ready(function() {

        var $batches = $("#results > ul > div.article > li > a.result");
        var $buttons = $(".btn").on("click", function() {
  
            var active = $buttons.removeClass("active")
                         .filter(this)
                         .addClass("active")
                         .data("filter");
  
            $batches
             .hide()
             .filter( "." + active )
             .fadeIn(450);

        });
   		

        $("#live-filter").keyup(function(){
     
            // Retrieve the input field text
            var filter = $(this).val();
     
            // Loop through the article list
            $(".article li").each(function(){
     
                // If the list item does not contain the text phrase fade it out
                if ($(this).text().search(new RegExp(filter, "i")) < 0) {
                    $(this).fadeOut();
     
                // Show the list item if the phrase matches
                } else {
                    $(this).show();
                }
            });
     
        });


	});

]]>
	</script>
  </head>
  <body>
    <div id="heading">
      <h1>
        WebInject Results
        (
        <A href="http://localhost/DEV/Summary.xml"> DEV </A>
        /
        <A href="http://localhost/PAT/Summary.xml"> PAT </A>
        /
        <A href="http://localhost/PROD/Summary.xml"> PROD </A>
        )
      </h1>
      <br />
      <h2>
         <xsl:value-of select="summary/channel/title"/>
         &#160;&#160;&#160;&#160;&#160; &#160;&#160;&#160;&#160;&#160;  &#160;&#160;&#160;&#160;&#160; &#160;&#160;&#160;&#160;&#160;
         <a href="{summary/channel/link}">(Click for previous day's results)</a>
      </h2>
    </div>

    <div id="filter">
        <button class="active btn" data-filter="result">Show All</button>
        <button class="btn" data-filter="pass">Passed</button>
        <button class="btn" data-filter="pend">Pending</button>
        <button class="btn" data-filter="fail">Failed</button>
        <button class="btn" data-filter="sanity">Sanity Failed</button>

        <form id="live-search" action="" class="inputbox" method="post">
            <fieldset>
                <input type="text" class="text-input" id="live-filter" value="" />
            </fieldset>
        </form>

    </div>


    <div class="spacer"></div>
    
    <div id="results">
    <ul>
      <xsl:for-each select="summary/channel/item">
      <div class="article">
        <xsl:if test="contains(title, 'PASS')">
           <li><a class="result pass" href="{link}" rel="bookmark"><xsl:value-of select="title"/></a></li>
        </xsl:if>        
        <xsl:if test="contains(title, 'PEND')">
           <li><a class="result pend" href="{link}" rel="bookmark"><xsl:value-of select="title"/></a></li>
        </xsl:if>        
        <xsl:if test="contains(title, 'CORRUPT')">
           <li><a class="result corrupt" href="{link}" rel="bookmark"><xsl:value-of select="title"/></a></li>
        </xsl:if>        
        <xsl:if test="contains(title, 'FAILED')">
            <xsl:choose>
                <xsl:when test="contains(title, 'SANITY FAILURE')">
                    <li><a class="result sanity" href="{link}" rel="bookmark"><xsl:value-of select="title"/></a></li>
                </xsl:when>        
                <xsl:otherwise>        
                    <li><a class="result fail" href="{link}" rel="bookmark"><xsl:value-of select="title"/></a></li>
                </xsl:otherwise>
            </xsl:choose>    
        </xsl:if>        
      </div>
      </xsl:for-each>
      </ul>
    </div>
</body>
</html>
</xsl:template>
</xsl:stylesheet>
