using System;
using System.Collections.Generic;
using System.IO;
using System.Xml.Serialization;

public partial class Setup_Completed : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        divStepBeforeInstalled.Visible = false;
        divStepCompleate.Visible = false;

        Guid gSetupKey = Guid.Empty;
        try
        {
            String strSetupKey = Request["Setup"];
            if (!String.IsNullOrEmpty(strSetupKey))
                gSetupKey = new Guid(strSetupKey);
        }
        catch
        {
        }

        if (Blogsa.IsInstalled && Blogsa.InstallKey == gSetupKey)
        {
            SaveAllData();
        }

        if (!String.IsNullOrEmpty((string)Session["Password"]))
        {
            divStepCompleate.Visible = true;
            ltCompleate.Text = Language.Setup["Compleate"].Replace("{Password}", (string)Session["Password"]);
        }
        else if (!Blogsa.IsInstalled)
            Response.Redirect("Default.aspx");
        else
            divStepBeforeInstalled.Visible = true;
    }

    private void SaveAllData()
    {
        XmlRootAttribute root = new XmlRootAttribute();
        root.ElementName = "Data";
        root.IsNullable = true;
        XmlSerializer dataSerializer = new XmlSerializer(typeof(BSData), root);
        using (TextReader reader = new StreamReader(Server.MapPath(String.Format("~/Setup/Data/{0}.xml", Session["lang"]))))
        {
            BSData data = (BSData)dataSerializer.Deserialize(reader);

            if (data != null)
            {
                if (data.Sites != null)
                    foreach (BSSite bsSite in data.Sites)
                        bsSite.Save();

                if (data.Settings != null)
                    foreach (BSSetting bsSetting in data.Settings)
                        bsSetting.Save();

                if (data.Posts != null)
                    foreach (BSPost bsPost in data.Posts)
                        bsPost.Save();

                if (data.MenuGroups != null)
                    foreach (BSMenuGroup bsMenuGroup in data.MenuGroups)
                        bsMenuGroup.Save();

                if (data.Menus != null)
                    foreach (BSMenu bsMenu in data.Menus)
                        bsMenu.Save();

                if (data.Users != null)
                    foreach (BSUser bsUser in data.Users)
                        bsUser.Save();

                if (data.Widgets != null)
                    foreach (BSWidget bsWidget in data.Widgets)
                        bsWidget.Save();

                if (data.Links != null)
                    foreach (BSLink bsLink in data.Links)
                        bsLink.Save();

                if (data.Terms != null)
                    foreach (BSTerm bsTerm in data.Terms)
                        bsTerm.Save();

                Blogsa.Settings = null;
            }
        }

        if (Session["Password"] == null)
        {
            string password = BSHelper.GetRandomStr(8);
            BSUser user = BSUser.GetUserByUserName("admin");
            user.Password = BSHelper.GetMd5Hash(password);
            user.Save();
            Session["Password"] = password;
        }

        Session["Step"] = "Finish";
        Response.Redirect("Completed.aspx");
    }
}