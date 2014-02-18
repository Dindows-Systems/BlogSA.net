<%@ Control Language="C#" ClassName="View" %>
<%@ Import Namespace="System.Xml" %>
<%@ Import Namespace="System.Collections.Generic" %>
<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        Response.Clear();
        XmlTextWriter writer = new XmlTextWriter(Response.OutputStream, System.Text.Encoding.UTF8);
        WriteRSSPrologue(writer);

        List<BSTerm> tags = BSTerm.GetTerms(TermTypes.Tag);

        foreach (BSTerm tag in tags)
        {
            double tagcount = tag.Objects.Count;
            if (tagcount > 0)
            {
                double totaltag = tags.Count;
                double fontweight = ((100 / totaltag) * tagcount) * 100;
                string style = "color:#ff0000;cursor:pointer;font-size:";
                if (fontweight >= 99)
                    style += "16px;";
                else if (fontweight >= 70)
                    style += "14px;";
                else if (fontweight >= 40)
                    style += "12px;";
                else if (fontweight >= 15)
                    style += "10px;";
                else if (fontweight >= 3)
                    style += "8px;";
                
                string _href = BSHelper.GetPermalink("Tag", tag.Code, Blogsa.UrlExtension); 
                
                string title = tag.Name;
                AddXMLItem(writer, _href, fontweight.ToString(), title, "tag", style);
            }
        }
        WriteRSSClosing(writer);
        writer.Flush();
        writer.Close();
        Response.ContentEncoding = System.Text.Encoding.UTF8;
        Response.ContentType = "text/xml";
        Response.Cache.SetCacheability(HttpCacheability.Public);
        Response.End();
    }

    public XmlTextWriter WriteRSSPrologue(XmlTextWriter writer)
    {
        writer.WriteStartElement("tags");
        return writer;
    }

    public XmlTextWriter AddXMLItem(XmlTextWriter writer, string _href, string _class, string _title, string _rel, string _style)
    {
        writer.WriteStartElement("a");
        writer.WriteAttributeString("href", _href);
        //writer.WriteAttributeString("class", _class);
        writer.WriteAttributeString("title", _title);
        writer.WriteAttributeString("rel", _rel);
        writer.WriteAttributeString("style", _style);
        writer.WriteValue(_title);
        writer.WriteEndElement();
        return writer;
    }

    public XmlTextWriter WriteRSSClosing(XmlTextWriter writer)
    {
        return writer;
    }
</script>
