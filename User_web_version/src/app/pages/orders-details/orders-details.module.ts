import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { OrdersDetailsRoutingModule } from './orders-details-routing.module';
import { OrdersDetailsComponent } from './orders-details.component';
import { MDBBootstrapModule } from 'angular-bootstrap-md';
import { NgxSkeletonLoaderModule } from 'ngx-skeleton-loader';
import { NgxSpinnerModule } from 'ngx-spinner';
import { FormsModule } from '@angular/forms';

@NgModule({
  declarations: [
    OrdersDetailsComponent
  ],
  imports: [
    CommonModule,
    OrdersDetailsRoutingModule,
    MDBBootstrapModule.forRoot(),
    NgxSkeletonLoaderModule,
    NgxSpinnerModule,
    FormsModule
  ]
})
export class OrdersDetailsModule { }
