import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { SalonsRoutingModule } from './salons-routing.module';
import { SalonsComponent } from './salons.component';
import { CarouselModule } from 'ngx-owl-carousel-o';
import { MDBBootstrapModule } from 'angular-bootstrap-md';
import { NgxPaginationModule } from 'ngx-pagination';
import { NgxSkeletonLoaderModule } from 'ngx-skeleton-loader';
import { NgxSpinnerModule } from "ngx-spinner";
@NgModule({
  declarations: [
    SalonsComponent
  ],
  imports: [
    CommonModule,
    SalonsRoutingModule,
    CarouselModule,
    MDBBootstrapModule.forRoot(),
    NgxPaginationModule,
    NgxSkeletonLoaderModule,
    NgxSpinnerModule,
  ]
})
export class SalonsModule { }
