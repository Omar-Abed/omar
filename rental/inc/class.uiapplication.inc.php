<?php
	/**
	 * phpGroupWare - property: a part of a Facilities Management System.
	 *
	 * @author Sigurd Nes <sigurdne@online.no>
	 * @copyright Copyright (C) 2016 Free Software Foundation, Inc. http://www.fsf.org/
	 * This file is part of phpGroupWare.
	 *
	 * phpGroupWare is free software; you can redistribute it and/or modify
	 * it under the terms of the GNU General Public License as published by
	 * the Free Software Foundation; either version 2 of the License, or
	 * (at your option) any later version.
	 *
	 * phpGroupWare is distributed in the hope that it will be useful,
	 * but WITHOUT ANY WARRANTY; without even the implied warranty of
	 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	 * GNU General Public License for more details.
	 *
	 * You should have received a copy of the GNU General Public License
	 * along with phpGroupWare; if not, write to the Free Software
	 * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
	 *
	 * @license http://www.gnu.org/licenses/gpl.html GNU General Public License
	 * @internal Development of this application was funded by http://www.bergen.kommune.no/ and Nordlandssykehuset
	 * @package rental
	 * @subpackage application
	 * @version $Id: $
	 */
	phpgw::import_class('rental.uicommon');
	phpgw::import_class('rental.soapplication');
	phpgw::import_class('phpgwapi.datetime');

	include_class('rental', 'application', 'inc/model/');

	class rental_uiapplication extends rental_uicommon
	{

		public $public_functions = array
			(
			'add' => true,
			'index' => true,
			'query' => true,
			'view' => true,
			'edit' => true,
			'save' => true,
			'set_value' => true,
		);

		public function __construct()
		{
			parent::__construct();
			self::set_active_menu('rental::application');
			$GLOBALS['phpgw_info']['flags']['app_header'] .= '::' . lang('application');
		}

		private function get_status_options( $selected = 0 )
		{
			$status_options = array();
			$status_options[] = array(
				'id' => rental_application::STATUS_REGISTERED,
				'name' => lang('registered')
			);
			$status_options[] = array(
				'id' => rental_application::STATUS_PENDING,
				'name' => lang('pending')
			);
			$status_options[] = array(
				'id' => rental_application::STATUS_REJECTED,
				'name' => lang('rejected')
			);
			$status_options[] = array(
				'id' => rental_application::STATUS_APPROVED,
				'name' => lang('approved')
			);

			foreach ($status_options as &$entry)
			{
				$entry['selected'] = $entry['id'] == $selected ? 1 : 0;
			}
			return $status_options;
		}

		public function index()
		{
			if (!$this->isExecutiveOfficer())
			{
				phpgw::no_access();
			}

			if (phpgw::get_var('phpgw_return_as') == 'json')
			{
				return $this->query();
			}

			phpgwapi_jquery::load_widget('autocomplete');

			$status_options = $this->get_status_options();
			$function_msg = lang('application');

			$data = array(
				'datatable_name' => $function_msg,
				'form' => array(
					'toolbar' => array(
						'item' => array(
							array(
								'type' => 'filter',
								'name' => 'responsibility_id',
								'text' => lang('status'),
								'list' => $status_options
							),
							array('type' => 'autocomplete',
								'name' => 'dimb',
								'app' => 'property',
								'ui' => 'generic',
								'label_attr' => 'descr',
								//				'show_id'=> true,
								'text' => lang('dimb') . ':',
								'requestGenerator' => 'requestWithDimbFilter',
							),
						)
					)
				),
				'datatable' => array(
					'source' => self::link(array(
						'menuaction' => 'rental.uiapplication.index',
						'phpgw_return_as' => 'json'
					)),
					'allrows' => true,
					'new_item' => self::link(array('menuaction' => 'rental.uiapplication.add')),
					'editor_action' => '',
					'field' => array(
						array(
							'key' => 'title',
							'label' => lang('name'),
							'className' => '',
							'sortable' => true,
							'hidden' => false
						),
						array(
							'key' => 'is_area',
							'label' => 'Avdeling',
							'className' => '',
							'sortable' => true,
							'hidden' => false
						),
						array(
							'key' => 'status',
							'label' => lang('status'),
							'className' => '',
							'sortable' => true,
							'hidden' => false
						),
						array(
							'key' => 'assignedto',
							'label' => 'saksbehandler',
							'className' => '',
							'sortable' => true,
							'hidden' => false
						),
						array(
							'key' => 'type',
							'label' => lang('type'),
							'className' => '',
							'sortable' => false,
							'hidden' => false
						)
					)
				)
			);

			$parameters = array(
				'parameter' => array(
					array(
						'name' => 'id',
						'source' => 'id'
					)
				)
			);

			$data['datatable']['actions'][] = array
				(
				'my_name' => 'view',
				'text' => lang('show'),
				'action' => $GLOBALS['phpgw']->link('/index.php', array
					(
					'menuaction' => 'rental.uiapplication.view'
				)),
				'parameters' => json_encode($parameters)
			);

			$data['datatable']['actions'][] = array
				(
				'my_name' => 'edit',
				'text' => lang('edit'),
				'action' => $GLOBALS['phpgw']->link('/index.php', array
					(
					'menuaction' => 'rental.uiapplication.edit'
				)),
				'parameters' => json_encode($parameters)
			);

			$code = <<<JS
				var thousandsSeparator = '$this->thousandsSeparator';
				var decimalSeparator = '$this->decimalSeparator';
				var decimalPlaces = '$this->decimalPlaces';
				var currency_suffix = '$this->currency_suffix';
JS;

			$GLOBALS['phpgw']->js->add_code('', $code);

			self::add_javascript('rental', 'rental', 'application.index.js');
			phpgwapi_jquery::load_widget('numberformat');

			self::render_template_xsl('datatable_jquery', $data);
		}
		/*
		 * View the price item with the id given in the http variable 'id'
		 */

		public function view()
		{
			$GLOBALS['phpgw_info']['flags']['app_header'] .= '::' . lang('view');

			if (!self::isExecutiveOfficer())
			{
				phpgw::no_access();
			}

			$this->edit(array(), 'view');
		}
		/*
		 * Edit the price item with the id given in the http variable 'id'
		 */

		public function edit( $values = array(), $mode = 'edit' )
		{
			$GLOBALS['phpgw_info']['flags']['app_header'] .= '::' . lang('edit');
			if (!self::isExecutiveOfficer())
			{
				phpgw::no_access();
			}

			$application_id = phpgw::get_var('id', 'int');

			if (!empty($values['application_id']))
			{
				$application_id = $values['application_id'];
			}

			if ($application_id)
			{
				$application = rental_application::get($application_id);
			}
			else
			{
				if (!empty($values['application']))
				{
					$application = $values['application'];
				}
				else
				{
					$title = phpgw::get_var('application_title');
					$application = new rental_application();
					$application->set_title($title);
	//				$application->set_responsibility_id($responsibility_id);
	//				$application->set_price_type_id(1); // defaults to year

				}
			}

			//		$responsibility_title = ($application->get_responsibility_title()) ? $application->get_responsibility_title() : rental_socontract::get_instance()->get_responsibility_title($responsibility_id);

			$link_save = array(
				'menuaction' => 'rental.uiapplication.save'
			);

			$link_index = array(
				'menuaction' => 'rental.uiapplication.index',
			);

			$tabs = array();
			$tabs['application'] = array('label' => lang('application'), 'link' => '#application');
			$tabs['party'] = array('label' => lang('party'), 'link' => '#party');
			$tabs['assignment'] = array('label' => lang('assignment'), 'link' => '#assignment');

			$active_tab = 'showing';

//			$current_price_type_id = $application->get_price_type_id();
			$status_options = array();
//			foreach ($application->get_price_types() as $price_type_id => $price_type_title)
//			{
//				$selected = ($current_price_type_id == $price_type_id) ? 1 : 0;
//				$status_options[] = array('id' => $price_type_id, 'name' => lang($price_type_title),
//					'selected' => $selected);
//			}


			$composite_type = array();
			$composite_type[] = array('id' => 1, 'name' => 'Hybel');
			$composite_type[] = array('id' => 2, 'name' => 'Leilighet');

			$payment_method = array();
			$payment_method[] = array('id' => 1, 'name' => 'Faktura');
			$payment_method[] = array('id' => 2, 'name' => 'Trekk i lønn');
			$payment_method[] = array('id' => 3, 'name' => 'intern faktura');

			$bocommon = CreateObject('property.bocommon');

			$GLOBALS['phpgw']->jqcal->add_listener('date_start');
			$GLOBALS['phpgw']->jqcal->add_listener('date_end');
			$GLOBALS['phpgw']->jqcal->add_listener('assign_date_start');
			$GLOBALS['phpgw']->jqcal->add_listener('assign_date_end');

			$data = array(
				'form_action' => $GLOBALS['phpgw']->link('/index.php', $link_save),
				'cancel_url' => $GLOBALS['phpgw']->link('/index.php', $link_index),
				'lang_save' => lang('save'),
				'lang_cancel' => lang('cancel'),
				'value_ecodimb' => $application->get_ecodimb(),
				'value_ecodimb_descr' => ExecMethod('property.bogeneric.get_single_attrib_value', array(
					'type' => 'dimb',
					'id' => $application->get_ecodimb(),
					'attrib_name' => 'descr')
				),
				'district_list' => array('options' => $bocommon->select_district_list('', $application->get_district_id())),
				'composite_type_list' => array('options' => $bocommon->select_list($application->get_composite_type(), $composite_type)),
				'value_date_start' => $GLOBALS['phpgw']->common->show_date($application->get_date_start(), $this->dateFormat),
				'value_date_end' => $GLOBALS['phpgw']->common->show_date($application->get_date_end(), $this->dateFormat),
				'value_cleaning' => $application->get_cleaning(),
				'payment_method_list' => array('options' => $bocommon->select_list($application->get_payment_method(), $payment_method)),
				'value_application_id' => $application->get_id(),
				'status_list' => array('options' => $this->get_status_options($application->get_status())),
//				'lang_current_price_type' => lang($application->get_price_type_title()),
//				'lang_adjustable_text' => $application->get_adjustable_text(),
//				'lang_standard_text' => $application->get_standard_text(),
//				'value_title' => $application->get_title(),
//				'value_field_of_responsibility' => lang($responsibility_title),
//				'value_agresso_id' => $application->get_agresso_id(),
//				'is_area' => ($application->is_area()) ? 1 : 0,
//				'list_type' => array('options' => $status_options),
//				'value_price' => $application->get_price(),
//				'value_price_formatted' => number_format($application->get_price(), $this->decimalPlaces, $this->decimalSeparator, $this->thousandsSeparator) . ' ' . $this->currency_suffix,
//				'has_active_contract' => (rental_soapplication::get_instance()->has_active_contract($application->get_id())) ? 1 : 0,
//				'is_inactive' => ($application->is_inactive()) ? 1 : 0,
//				'is_adjustable' => ($application->is_adjustable()) ? 1 : 0,
//				'is_standard' => ($application->is_standard()) ? 1 : 0,
//				'responsibility_id' => $responsibility_id,
				'mode' => $mode,
				'tabs' => phpgwapi_jquery::tabview_generate($tabs, $active_tab),
			);
			phpgwapi_jquery::formvalidator_generate(array('date', 'security', 'file'));
			phpgwapi_jquery::load_widget('autocomplete');
			self::add_javascript('rental', 'rental', 'application.edit.js');

			self::render_template_xsl(array('application'), array($mode => $data));
		}
		/*
		 * To be removed
		 * Add a new price item to the database.  Requires only a title.
		 */

		public function add()
		{
			if (!self::isExecutiveOfficer())
			{
				phpgw::no_access();
			}

			$this->edit();
		}

		public function save()
		{
			_debug_array($_POST);
			$application_id = phpgw::get_var('id', 'int');

			if ($application_id)
			{
				$application = rental_application::get($application_id);
			}
			else
			{
				$application = new rental_application();
			}

			$application->set_ecodimb(phpgw::get_var('ecodimb', 'int'));
			$application->set_district_id(phpgw::get_var('district_id', 'int'));
			$application->set_composite_type(phpgw::get_var('composite_type_id', 'int'));
			$date_start = phpgwapi_datetime::date_to_timestamp(phpgw::get_var('date_start', 'string'));
			$application->set_date_start($date_start);
			$date_end = phpgwapi_datetime::date_to_timestamp(phpgw::get_var('date_end', 'string'));
			$application->set_date_start($date_end);

			$application->set_cleaning(phpgw::get_var('cleaning', 'bool'));
			$application->set_payment_method(phpgw::get_var('payment_method', 'int'));
			$application->set_identifier(phpgw::get_var('identifier'));
			$application->set_firstname(phpgw::get_var('firstname'));
			$application->set_lastname(phpgw::get_var('lastname'));
			$application->set_title(phpgw::get_var('title'));
			$application->set_company_name(phpgw::get_var('company_name'));
			$application->set_department(phpgw::get_var('department'));
			$application->set_address1(phpgw::get_var('address1'));
			$application->set_address2(phpgw::get_var('address2'));
			$application->set_postal_code(phpgw::get_var('postal_code'));
			$application->set_place(phpgw::get_var('place'));
			$application->set_account_number(phpgw::get_var('account_number'));
			$application->set_phone(phpgw::get_var('phone'));
			$application->set_email(phpgw::get_var('email'));
			$application->set_unit_leader(phpgw::get_var('unit_leader'));
			$application->set_comment(phpgw::get_var('comment'));
			$application->set_assign_date_start(phpgw::get_var('assign_date_start'));
			$application->set_assign_date_end(phpgw::get_var('assign_date_end'));
			$application->set_status(phpgw::get_var('status'));


			if(self::_validate($application))
			{
				if (rental_soapplication::get_instance()->store($application))
				{
					phpgwapi_cache::message_set(lang('messages_saved_form'), 'message');
					self::redirect(array(
						'menuaction' => 'rental.uiapplication.edit',
						'id'		=> $application->get_id()
						)
					);
				}
				else
				{
					phpgwapi_cache::message_set(lang('messages_form_error'), 'error');

				}
			}
			$this->edit(array(
				'id'	=>$application->get_id(),
				'application'	=> $application
				)
			);
		}


		private function _validate( $application )
		{
			return true;
		}
		
		public function set_value()
		{
			if (!self::isExecutiveOfficer())
			{
				return;
			}

			$field_name = phpgw::get_var('field_name');
			$value = phpgw::get_var('value');
			$id = phpgw::get_var('id');

			switch ($field_name)
			{
				case 'count':
					$value = (int)$value;
					break;
				case 'price':
					$value = trim(str_replace(array($this->currency_suffix, " "), '', $value));
					break;
				case 'date_start':
				case 'date_end':
					$value = phpgwapi_datetime::date_to_timestamp(phpgw::get_var('value'));
					break;
				default:
					$value = phpgw::get_var('value');
					break;
			}

			$application = rental_socontract_application::get_instance()->get_single($id);
			$application->set_field($field_name, $value);
			$result = rental_socontract_application::get_instance()->store($application);

			$message = array();
			if ($result)
			{
				$message['message'][] = array('msg' => lang('data has been saved'));
			}
			else
			{
				$message['error'][] = array('msg' => lang('data has not been saved'));
			}

			return $message;
		}

		/**
		 * (non-PHPdoc)
		 * @see rental/inc/rental_uicommon#query()
		 */
		public function query()
		{

			if ($GLOBALS['phpgw_info']['user']['preferences']['common']['maxmatchs'] > 0)
			{
				$user_rows_per_page = $GLOBALS['phpgw_info']['user']['preferences']['common']['maxmatchs'];
			}
			else
			{
				$user_rows_per_page = 10;
			}

			$order = phpgw::get_var('order');
			$draw = phpgw::get_var('draw', 'int');
			$columns = phpgw::get_var('columns');

			$start_index = phpgw::get_var('start', 'int', 'REQUEST', 0);
			$num_of_objects = (phpgw::get_var('length', 'int') <= 0) ? $user_rows_per_page : phpgw::get_var('length', 'int');
			$sort_field = ($columns[$order[0]['column']]['data']) ? $columns[$order[0]['column']]['data'] : 'agresso_id';
			$sort_ascending = ($order[0]['dir'] == 'desc') ? false : true;

			$search_for = '';
			$search_type = '';


			$filters = array();
			$result_objects = rental_soapplication::get_instance()->get($start_index, $num_of_objects, $sort_field, $sort_ascending, $search_for, $search_type, $filters);
			$object_count = 0;//rental_soapplication::get_instance()->get_count($search_for, $search_type, $filters);
			// Create an empty row set
			$rows = array();
			foreach ($result_objects as $record)
			{
				if (isset($record))
				{
					// ... add a serialized record
					$rows[] = $record->serialize();
				}
			}


			$result_data = array('results' => $rows);
			$result_data['total_records'] = $object_count;
			$result_data['draw'] = $draw;

			return $this->jquery_results($result_data);
		}
	}