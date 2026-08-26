import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { AwaitPaymentsRoutingModule } from './await-payments-routing.module';
import { AwaitPaymentsComponent } from './await-payments.component';
import { MDBBootstrapModule } from 'angular-bootstrap-md';
import { NgxPayPalModule } from 'ngx-paypal';
import { FormsModule } from '@angular/forms';

@NgModule({
  declarations: [
    AwaitPaymentsComponent
  ],
  imports: [
    CommonModule,
    AwaitPaymentsRoutingModule,
    MDBBootstrapModule.forRoot(),
    NgxPayPalModule,
    FormsModule,
  ]
})
export class AwaitPaymentsModule { }
