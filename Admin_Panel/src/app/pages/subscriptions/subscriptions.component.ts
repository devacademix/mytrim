import { Component, OnInit, ViewChild } from '@angular/core';
import { ModalDirective } from 'ngx-bootstrap/modal';
import { ApiService } from 'src/app/services/api.service';
import { UtilService } from 'src/app/services/util.service';
import Swal from 'sweetalert2';

@Component({
  selector: 'app-subscriptions',
  templateUrl: './subscriptions.component.html',
  styleUrls: ['./subscriptions.component.scss']
})
export class SubscriptionsComponent implements OnInit {
  @ViewChild('myModal2') public myModal2: ModalDirective;
  name: any = '';
  short_desc: any = '';
  features: any = '';
  price: any = '';
  signup_fee: any = '';
  grace_period: any = '';
  grace_interval: any = 'month';
  ckeConfig: any;
  action: any = 'create';
  id: any = '';
  list: any[] = [];
  dummy: any[] = [];
  page: number = 1;
  constructor(
    public util: UtilService,
    public api: ApiService
  ) {
    this.ckeConfig = {
      height: 200,
      language: "en",
      allowedContent: true,
      toolbar: [
        { name: "paragraph", items: ["NumberedList", "BulletedList"] },
      ]
    };
    this.getAll();
  }

  ngOnInit(): void {
  }


  getAll() {
    this.list = [];
    this.dummy = Array(5);
    this.api.get_private('v1/subscriptions/getAll').then((data: any) => {
      console.log(data);
      this.list = [];
      this.dummy = [];
      if (data && data.status && data.status == 200) {
        this.list = data.data;
      }
    }, error => {
      console.log(error);
      this.list = [];
      this.dummy = [];
      this.util.apiErrorHandler(error);
    }).catch((error: any) => {
      console.log(error);
      this.list = [];
      this.dummy = [];
      this.util.apiErrorHandler(error);
    });
  }

  createNew() {
    this.action = 'create';
    this.myModal2.show();
  }

  createSubscription() {
    console.log('create new');
    if (this.name == '' || this.name == null || this.short_desc == '' || this.short_desc == null || this.features == null || this.features == '' || this.grace_period == '' || this.grace_period == null) {
      this.util.error(this.util.translate('All Fields are required'));
      return false;
    }
    const param = {
      name: this.name,
      short_desc: this.short_desc,
      features: this.features,
      price: (this.price != '' && this.price != null) ? this.price : 0,
      signup_fee: (this.signup_fee != '' && this.signup_fee != null) ? this.signup_fee : 0,
      grace_period: this.grace_period,
      grace_interval: this.grace_interval
    }
    console.log(param);
    this.util.show();
    this.api.post_private('v1/subscriptions/create', param).then((data: any) => {
      this.util.hide();
      console.log(data);
      if (data && data.status && data.status == 200) {
        this.myModal2.hide();
        this.cleanData();
        this.getAll();
      }
    }, error => {
      console.log(error);
      this.util.hide();
      this.util.apiErrorHandler(error);
    }).catch((error) => {
      console.log(error);
      this.util.hide();
      this.util.apiErrorHandler(error);
    });
  }

  updateSubscription() {
    console.log('update existing');
    console.log(this.id);
    console.log('create new');
    if (this.name == '' || this.name == null || this.short_desc == '' || this.short_desc == null || this.features == null || this.features == '' || this.grace_period == '' || this.grace_period == null) {
      this.util.error(this.util.translate('All Fields are required'));
      return false;
    }
    const param = {
      id: this.id,
      name: this.name,
      short_desc: this.short_desc,
      features: this.features,
      price: (this.price != '' && this.price != null) ? this.price : 0,
      signup_fee: (this.signup_fee != '' && this.signup_fee != null) ? this.signup_fee : 0,
      grace_period: this.grace_period,
      grace_interval: this.grace_interval
    }
    console.log(param);
    this.util.show();
    this.api.post_private('v1/subscriptions/update', param).then((data: any) => {
      this.util.hide();
      console.log(data);
      if (data && data.status && data.status == 200) {
        this.myModal2.hide();
        this.cleanData();
        this.getAll();
      }
    }, error => {
      console.log(error);
      this.util.hide();
      this.util.apiErrorHandler(error);
    }).catch((error) => {
      console.log(error);
      this.util.hide();
      this.util.apiErrorHandler(error);
    });
  }

  cleanData() {
    this.action = 'create';
    this.id = '';
    this.name = '';
    this.short_desc = '';
    this.features = '';
    this.price = '';
    this.signup_fee = '';
    this.grace_interval = 'month';
    this.grace_period = '';
  }

  statusUpdate(item: any) {
    console.log(item);
    Swal.fire({
      title: this.util.translate('Are you sure?'),
      text: this.util.translate('To update this item?'),
      icon: 'question',
      showConfirmButton: true,
      confirmButtonText: this.util.translate('Yes'),
      showCancelButton: true,
      cancelButtonText: this.util.translate('Cancel'),
      backdrop: false,
      background: 'white'
    }).then((data) => {
      if (data && data.value) {
        console.log('update it');
        const body = {
          id: item.id,
          status: item.status == 0 ? 1 : 0
        };
        console.log("======", body);
        this.util.show();
        this.api.post_private('v1/subscriptions/update', body).then((data: any) => {
          this.util.hide();
          console.log("+++++++++++++++", data);
          if (data && data.status && data.status == 200 && data.success) {
            this.util.success(this.util.translate('Status Updated !'));
            this.getAll();
          }
        }, error => {
          this.util.hide();
          console.log('Error', error);
          this.util.apiErrorHandler(error);
        }).catch(error => {
          this.util.hide();
          console.log('Err', error);
          this.util.apiErrorHandler(error);
        });
      }
    });
  }

  deleteItem(item: any) {
    console.log(item);
    Swal.fire({
      title: this.util.translate('Are you sure?'),
      text: this.util.translate('To delete this item?'),
      icon: 'question',
      showConfirmButton: true,
      confirmButtonText: this.util.translate('Yes'),
      showCancelButton: true,
      cancelButtonText: this.util.translate('Cancel'),
      backdrop: false,
      background: 'white'
    }).then((data) => {
      if (data && data.value) {
        console.log('update it');
        console.log(item);
        console.log(item);
        const body = {
          id: item.id,
        };
        console.log("======", body);
        this.util.show();
        this.api.post_private('v1/subscriptions/destroy', body).then((data: any) => {
          this.util.hide();
          console.log("+++++++++++++++", data);
          if (data && data.status && data.status == 200 && data.success) {
            this.util.success(this.util.translate('Status Updated !'));
            this.getAll();
          }
        }, error => {
          this.util.hide();
          console.log('Error', error);
          this.util.apiErrorHandler(error);
        }).catch(error => {
          this.util.hide();
          console.log('Err', error);
          this.util.apiErrorHandler(error);
        });
      }
    });
  }

  updateInfo(item: any) {
    console.log(item);
    if (item && item.id) {
      this.action = 'update';
      this.id = item.id;
      this.name = item.name;
      this.short_desc = item.short_desc;
      this.features = item.features;
      this.price = item.price;
      this.signup_fee = item.signup_fee;
      this.grace_period = item.grace_period;
      this.grace_interval = item.grace_interval;
      this.myModal2.show();
    }
  }
}
