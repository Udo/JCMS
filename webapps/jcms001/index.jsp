<%
/**
  * This is the base page, it provides the basic html
  * framework for the application
  *
  * @author udo.schroeter@trionic.de
*/
%>
<jsp:include page="modules/page.start.jsp"/>
<jsp:include page="modules/page.head.jsp"/>

<%
  /**
    * modules need to be loaded at runtime, the default module name
    * is "default.jsp".
    */
  String modulename = "default";
  if (request.getParameter("m") != null)
      modulename = request.getParameter("m");

   /**
    * This is tomcat-specific and needs to be replaced with
    * whatever runtime object the app server has to offer.
    * What happens here is that we do dynamic inclusion with
    * the server's runtime engine. Quite PHPey, but works
    * very nice to create a fault tolerant structure without
    * using frames...
    */
  try
  {
    org.apache.jasper.runtime.JspRuntimeLibrary.include(
      request, response, "modules/" + modulename + ".jsp", out, false);
  }
  catch (java.lang.Exception e)
  {
    out.print("<h3>Error, cannot process module: </h3><h4>"+e.toString()+"</h4>");
    e.printStackTrace();
  }
%>


<jsp:include page="modules/page.foot.jsp"/>
<jsp:include page="modules/page.end.jsp"/>
