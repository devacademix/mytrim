import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { ProductCheckoutRoutingModule } from './product-checkout-routing.module';
import { ProductCheckoutComponent } from './product-checkout.component';
import { MDBBootstrapModule } from 'angular-bootstrap-md';
import { NgxPayPalModule } from 'ngx-paypal';
import { FormsModule } from '@angular/forms';

@NgModule({
  declarations: [
    ProductCheckoutComponent
  ],
  imports: [
    CommonModule,
    ProductCheckoutRoutingModule,
    MDBBootstrapModule,
    FormsModule,
    NgxPayPalModule
  ]
})
export class ProductCheckoutModule { }
