<?php
	//include common logic for all templates
	include("common.php");
?>
<div class="identifier-header">
	<h1><img src="<?php echo ACTIVITYCALENDAR_IMAGE_PATH ?>images/32x32/custom/contact.png" /><?php echo lang('group') ?></h1>
</div>
<div class="yui-content">
	<div id="details">
		<form action="#" method="post">
			<input type="hidden" name="id" value="<?php if($group->get_id()){ echo $group->get_id(); } else { echo '0'; }  ?>"/>
			<dl class="proplist-col">
				<dt><label for="orgname">Gruppenavn</label></dt>
				<dd><?php echo $group->get_name();?></dd>
				<dt><label for="group_description">Beskrivelse</label></dt>
				<dd>
				<?php if($editable){?>
					<textarea rows="10" cols="100" name="group_description"><?php echo $group->get_description();?></textarea>
				<?php }else{?>
					<?php echo $group->get_description();?>
				<?php }?>
				</dd>
				<dt><label>Kontaktperson 1</label></dt>
				<?php if($contactperson1){?>
				<dd><input type="hidden" name="contact1_id" value="<?php echo $contactperson1->get_id();?>"/></dd>
				<dt><label for="contact1_name">Navn</label></dt>
				<dd>
					<input type="text" name="contact1_name" value="<?php echo $contactperson1->get_name();?>"/><br/>
				</dd>
				<dt><label for="contact1_phone">Telefon</label></dt>
				<dd>
					<input type="text" name="contact1_phone" value="<?php echo $contactperson1->get_phone();?>"/>
				</dd>
				<dt><label for="contact1_mail">E-post</label></dt>
				<dd>
					<input type="text" name="contact1_email" value="<?php echo $contactperson1->get_email();?>"/>
				</dd>
				<?php }?>
				<dt><label>Kontaktperson 2</label></dt>
				<?php if($contactperson2){?>
				<dd><input type="hidden" name="contact2_id" value="<?php echo $contactperson2->get_id();?>"/></dd>
				<dt><label for="contact1_name">Navn</label></dt>
				<dd>
					<input type="text" name="contact2_name" value="<?php echo $contactperson2->get_name();?>"/><br/>
				</dd>
				<dt><label for="contact1_phone">Telefon</label></dt>
				<dd>
					<input type="text" name="contact2_phone" value="<?php echo $contactperson2->get_phone();?>"/>
				</dd>
				<dt><label for="contact1_mail">E-post</label></dt>
				<dd>
					<input type="text" name="contact2_email" value="<?php echo $contactperson2->get_email();?>"/>
				</dd>
				<?php }?>
			</dl>
			<div class="form-buttons">
				<?php
					if ($editable) {
						echo '<input type="submit" name="save_group" value="' . lang('save') . '"/>';
						echo '<input type="submit" name="store_group" value="' . lang('store') . '"/>';
					}
				?>
			</div>
		</form>
	</div>
</div>
				