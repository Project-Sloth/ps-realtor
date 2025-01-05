<script lang="ts">
	import Image from "@components/generic/Image.svelte"

	export let url: string;
	export let label: string;
</script>

<article class="property-image-card">
    <div class="property-image-card-image">
        <Image src={url} alt={label} fallback="images/fallback-image.svg"></Image>

		{#if $$slots.default}
			<div class="property-image-card-actions">
				<slot/>
			</div>
		{/if}
    </div>
    <small>{label}</small>
</article>

<style>
	.property-image-card {
		display: flex;
		flex-direction: column;
		place-items: center;
		text-align: center;
	}

	.property-image-card-image {
		position: relative;
		width: 100%;
		height: var(--property-image-card-height, auto);

		border-radius: 6px;	
	}

	.property-image-card-image > :global(img) {
		border-radius: 6px;
		height: 100%;
		object-fit: cover;
		text-align: center;
	}

	.property-image-card-actions {
		position: absolute;	
		display: flex;
		place-items: center;
		place-content: center;
		gap: .5rem;

		top: 0%;
		width: 100%;
		height: 100%;

		visibility: hidden;
		opacity: 0;
		transition: visibility 0s .2s, opacity .2s ease-out;

		border-radius: 6px;
		background-color: var(--black-opaque-color-3);
	}

	.property-image-card:hover .property-image-card-actions {
		visibility: visible;
		opacity: 1;
		transition: opacity .2s ease-in;
	}
</style>