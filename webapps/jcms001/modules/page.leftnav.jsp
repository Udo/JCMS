<!--
<?php

  $ctr = 0;



  function table_start($caption, &$dataset)
  {
  ?>
    <table width="149" border="0" cellspacing="1" cellpadding="1" bgcolor="#F0F0F0">
      <tr bgcolor="#<?php
        if ($dataset['no_key']==13 || $dataset['no_key']==33)
          print('6BA76B');
        else
          print('778EA6');
      ?>">
        <td height="20" width="4"></td>
        <td height="20" background="images/tabhead2<?php
        if ($dataset['no_key']==13 || $dataset['no_key']==33)
          print('green');
        ?>.png"><span class="tdlight">
        &nbsp;<?php print($caption); ?>
        </span></td>
      </tr>
  <?php
  }

  function table_end()
  {
  print('</table>
    <table width="149" cellpadding="0" cellspacing="0">
      <tr>
      <td bgcolor="#F0F0F0" height="8"></td>
      </tr>
    </table>
    ');
  }

  function table_entry($caption, $link)
  {
  global $ctr;
  $isIEx = str_match('MSIE', $_SERVER['HTTP_USER_AGENT']);
  $ctr++;
  ?>
  <tr height="20"
    onMouseOver="setPointer(this, <?php print($ctr); ?>, 'over', '#F0F0F0', '#D0D0D0', '#BBBBBB', '');"
    onMouseOut="setPointer(this, <?php print($ctr); ?>, 'out', '#F0F0F0', '#D0D0D0', '#BBBBBB', '');"
    onMouseDown="setPointer(this, <?php print($ctr); ?>, 'click', '#F0F0F0', '#D0D0D0', '#BBBBBB', '<?php print($link); ?>');">
      <td bgcolor="#CCCCCC" width="4"></td>
      <td class="navtable" bgcolor="#F0F0F0">
      <?php
        if ($isIEx == false)
          print('<a href="'.$link.'" class="speciallink">');
        else
          print('<span class="speciallink">');
        print('&nbsp;'.$caption);
        if ($isIEx == false)
          print('</a>');
        else
          print('</span>');
      ?>
      </td>
    </tr>
  <?php
  }
?>
-->

<td width="200" valign="top" background="images/tab_background1.png">
<?php
$blocklist = DB_GetList(
  'SELECT * FROM '.$config['db.table.nodes'].
  ' WHERE no_parent="0" AND no_xchar1="'.$config['language'].'" ORDER BY no_xint1;');

foreach ($blocklist as $dataset)
  {
  table_start($dataset['no_title'], $dataset);

  $menulist = DB_GetList(
    'SELECT * FROM '.$config['db.table.nodes'].
    ' WHERE no_parent="'.$dataset['no_key'].'"'.
    ' AND no_xchar1="'.$config['language'].'" ORDER BY no_xint1;');

  foreach ($menulist as $edataset)
    {
    if ($edataset['no_xint3']=='1')
      {
      // statischen Link bauen
      $link = $edataset['no_link'];
      }
    else
      {
      // dynamischen Link bauen
      $link = '?m=document&key='.$edataset['no_link'];
      if ($config['rights.canedit'] == true)
        $link = $link . '&parent=0';
      }
    table_entry($edataset['no_title'], $link);
    }

  table_end();
  }

if ($config['rights.canedit'])
  {
  print('<a href="?m=dyn/editblocks"><font size="1">[ Edit Blocks ]</font></a><br>');
  }
?>
<table width="150" cellpadding="1" cellspacing="1">
  <tr height="7">
    <td width="6"></td>
    <td bgcolor="#F0F0F0" class="speciallink">
  </tr>
  <tr><form action="?m=document&key=166517602108" method="post">
    <td></td>
    <td bgcolor="#F0F0F0" height="7" class="speciallink">
      Suche:
      <input type="hidden" name="searchmethod" value="fulltext">
      <input type="Text" name="searchkey" value="" size="15" maxlength="">
      <input type="Submit" name="" value="&gt;" class="inputbutton">     &nbsp;
    </td>
  </tr></form>
  <tr height="8">
    <td></td>
    <td bgcolor="#F0F0F0" class="speciallink">
  </tr>
</table>

</td>