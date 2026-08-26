import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { AwaitPaymentsProductRoutingModule } from './await-payments-product-routing.module';
import { AwaitPaymentsProductComponent } from './await-payments-product.component';
import { MDBBootstrapModule } from 'angular-bootstrap-md';
import { NgxPayPalModule } from 'ngx-paypal';
import { FormsModule } from '@angular/forms';

@NgModule({
  declarations: [
    AwaitPaymentsProductComponent
  ],
  imports: [
    CommonModule,
    AwaitPaymentsProductRoutingModule,
    MDBBootstrapModule.forRoot(),
    NgxPayPalModule,
    FormsModule,
  ]
})
export class AwaitPaymentsProductModule { }
