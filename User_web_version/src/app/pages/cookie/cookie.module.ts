import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { CookieRoutingModule } from './cookie-routing.module';
import { CookieComponent } from './cookie.component';
import { NgxSkeletonLoaderModule } from 'ngx-skeleton-loader';

@NgModule({
  declarations: [
    CookieComponent
  ],
  imports: [
    CommonModule,
    CookieRoutingModule,
    NgxSkeletonLoaderModule
  ]
})
export class CookieModule { }
