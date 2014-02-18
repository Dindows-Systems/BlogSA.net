<%@ Control Language="C#" ClassName="Calendar" %>
<script type="text/javascript" src="<%=Blogsa.Url %>Widgets/FlashTagCloud/swfobject.js"></script>
<div class="widget">
<div class="title"><span>Tag Bulutu</span></div>
<div class="content">
        <div id="widgetTagCloud">
	        <script type="text/javascript">
		        var s1 = new SWFObject("<%=Blogsa.Url %>Widgets/FlashTagCloud/tagcloud.swf","tagCloud","210","170","9","#FFFFFF");
		        s1.addParam("allowfullscreen","false");
		        s1.addParam("allowscriptaccess","always");
		        s1.addParam("flashvars","blog_url=<%=Blogsa.Url %>");
		        s1.write("widgetTagCloud");
	        </script>
        </div>
</div>
</div>