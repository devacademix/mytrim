import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { BlogDetailRoutingModule } from './blog-detail-routing.module';
import { BlogDetailComponent } from './blog-detail.component';
import { NgxSkeletonLoaderModule } from 'ngx-skeleton-loader';

@NgModule({
  declarations: [
    BlogDetailComponent
  ],
  imports: [
    CommonModule,
    BlogDetailRoutingModule,
    NgxSkeletonLoaderModule
  ]
})
export class BlogDetailModule { }
