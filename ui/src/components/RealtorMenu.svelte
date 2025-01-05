<script lang="ts">
	import { CONFIG, REALTOR_GRADE, TEMP_HIDE } from '@store/stores'
	import type { Tab } from '@typings/type'
	import { SendNUI } from '@utils/SendNUI'
	import ApartmentsBase from './apartments/ApartmentsBase.svelte'
	import Button from './generic/Button.svelte'
	import ListPropertiesBase from './list-properties/ListPropertiesBase.svelte'
	import PropertyBase from './properties/PropertyBase.svelte'

	const getInitialTabs: () => Tab[] = () => ([
		{
			name: 'Properties',
			icon: 'fas fa-home',
			component: PropertyBase,
		},
	]);

	// basic available tabs
	let availableNavTabs: Tab[] = [];

	// available tabs based on properties/config values of user
	REALTOR_GRADE.subscribe((value) => {
		availableNavTabs = getInitialTabs();

		if (value >= $CONFIG.setApartments)
			availableNavTabs.push({
				name: 'Apartments',
				icon: 'fa-building',
				component: ApartmentsBase,
			});

		if (value >= $CONFIG.listNewProperty)
			availableNavTabs.push({
				name: 'List Property',
				icon: 'fa-plus-circle',
				component: ListPropertiesBase,
			});
	});

	let selectedTab: Tab = availableNavTabs[0];

	function selectTab(tab: Tab) {
		if (tab.component)
			selectedTab = tab;
		else if (tab.action)
			tab.action();		
	}

	let footerNavs: Tab[] = [		
		// {
		// 	name: 'Help Center',
		// 	icon: 'fas fa-life-ring',
		// 	component: '',
		// },
		{
			name: 'Logout',
			icon: 'fas fa-arrow-right-from-bracket',
			action: () => SendNUI("hideUI", {})
		}
	];

	const year = new Date().getFullYear();

	function openProject() {
		if ('invokeNative' in window)
			(window as any).invokeNative('openUrl', 'https://github.com/Project-Sloth');
	}
</script>

<div class="realtor-menu" class:hide={$TEMP_HIDE}>
	<aside class="realtor-menu-sidebar">
		<header>Los Santos Realtors</header>

		<nav>
			{#each availableNavTabs as tab}
				<Button
					active={selectedTab.name === tab.name}
					status={selectedTab.name === tab.name ? 'primary' : 'none'} 
					icon={tab.icon} 
					block 
					justify="start"
					click={() => selectTab(tab)}>
					{tab.name}
				</Button>
			{/each}

			<div class="spacer"></div>

			{#each footerNavs as tab}
				<Button
					active={selectedTab.name === tab.name}
					status={selectedTab.name === tab.name ? 'primary' : 'basic'}
					style="outline"
					icon={tab.icon} 
					block 
					justify="start"
					click={() => selectTab(tab)}>
					{tab.name}
				</Button>
			{/each}
		</nav>

		<footer>
			&copy; {year} <a href="https://github.com/Project-Sloth" target="_blank" on:click={openProject}>Project Sloth <i class="fas fa-up-right-from-square small"></i></a>
		</footer>
	</aside>

	<section class="realtor-menu-content">
		<svelte:component this={selectedTab.component} />
	</section>
</div>

<style>
	.realtor-menu {
		position: relative;

		display: flex;
		flex-direction: row;		

		width: 75%;
		height: 80%;

		overflow: hidden;

		background-color: var(--background-color);
	}

	.realtor-menu.hide {
		opacity: 0;
	}

	.realtor-menu-sidebar {
		flex: 20% 0 0;

		display: flex;
		flex-direction: column;
		justify-content: space-between;

		padding: 1rem;
		gap: 1rem;

		border-right: 0.1px solid var(--light-border-color);
		background-color: var(--light-border-color-half-opaque);
	}

	.realtor-menu-sidebar > header {
		padding: 1rem;

		background-image: url('images/app-banner.webp');
        background-size: cover;
        background-position: center center;
        background-repeat: no-repeat;

		border-radius: 3px;
		@apply text-2xl;
		font-weight: 700;
		text-shadow: 3px 2px 5px #000;
		color: whitesmoke;
		text-align: center;

		user-select: none;
	}

	.realtor-menu-sidebar > nav {
		flex: 1;
		display: flex;
		flex-direction: column;
		gap: .5rem;
	}

	.realtor-menu-sidebar > nav > :global(.btn) {
		padding: 0.5rem 1rem;
		gap: 1rem;
	}

	.realtor-menu-sidebar > footer {
		text-align: center;
	}

	.realtor-menu-sidebar > footer > a {
		display: inline-flex;
		flex-direction: row;
		gap: 0.5rem;
		place-items: center;
	}

	.realtor-menu-content { 
		position: relative;

		flex: 1;
		height: 100%;

		padding: 1rem;
	}

	@media only screen and (max-width: 1366px) {
		.realtor-menu {
			width: 95%;
			height: 90%;
		}

		.realtor-menu-sidebar {
			flex-basis: 26%;
		}
	}

	@media only screen and (min-width: 1921px) {
		.realtor-menu-sidebar {
			flex-basis: 18rem;
		}
	}
</style>